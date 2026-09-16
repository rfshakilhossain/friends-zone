import 'package:flutter/material.dart';

import '../services/supabase_service.dart';
import '../services/user_service.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF090412);
    const card = Color(0xFF170B25);
    const pink = Color(0xFFFF2E93);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: UserService.instance.visibleUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ErrorState(
              message: 'Unable to load Friends Zone users.',
              onRetry: () {},
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: pink,
              ),
            );
          }

          final currentId =
              SupabaseService.instance.currentUser?.id;

          final users = (snapshot.data ?? const [])
              .where(
                (user) =>
                    user['id'] != null &&
                    user['id'].toString() != currentId,
              )
              .toList();

          if (users.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No other visible Friends Zone users yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: users.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 9),
            itemBuilder: (context, index) {
              final user = users[index];

              final name =
                  (user['display_name'] ??
                          'Friends Zone User')
                      .toString();

              final avatar =
                  (user['avatar_url'] ?? '').toString();

              final online = user['is_online'] == true;

              return Container(
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(.06),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  leading: _Avatar(
                    name: name,
                    avatarUrl: avatar,
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: online
                              ? Colors.greenAccent
                              : Colors.white24,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        online
                            ? 'Online now'
                            : 'Offline',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: pink,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          userName: name,
                          otherUid:
                              user['id'].toString(),
                          avatarUrl: avatar,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String userName;
  final String? otherUid;
  final String? avatarUrl;

  const ChatScreen({
    super.key,
    required this.userName,
    this.otherUid,
    this.avatarUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  final _service = SupabaseService.instance;

  bool _sending = false;

  Future<void> _send() async {
    final text = _messageController.text.trim();

    if (text.isEmpty ||
        widget.otherUid == null ||
        _sending) {
      return;
    }

    setState(() {
      _sending = true;
    });

    try {
      await _service.sendMessage(
        otherUid: widget.otherUid!,
        text: text,
      );

      _messageController.clear();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Message failed. Please try again.',
          ),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF090412);
    const pink = Color(0xFFFF2E93);

    final otherUid = widget.otherUid;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        titleSpacing: 8,
        title: Row(
          children: [
            _Avatar(
              name: widget.userName,
              avatarUrl: widget.avatarUrl ?? '',
              radius: 19,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: otherUid == null
                ? const Center(
                    child: Text(
                      'Chat user is not available.',
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  )
                : StreamBuilder<
                    List<Map<String, dynamic>>>(
                    stream:
                        _service.messagesStream(otherUid),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Unable to load messages.',
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        );
                      }

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: pink,
                          ),
                        );
                      }

                      final messages =
                          snapshot.data ?? const [];

                      if (messages.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              'No messages yet.\nStart the conversation.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white54,
                                height: 1.5,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        reverse: false,
                        padding: const EdgeInsets.fromLTRB(
                          14,
                          18,
                          14,
                          18,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message =
                              messages[index];

                          final sender =
                              message['sender_id']
                                  ?.toString();

                          final isMe = sender ==
                              _service.currentUser?.id;

                          return _MessageBubble(
                            text:
                                (message['text'] ?? '')
                                    .toString(),
                            isMe: isMe,
                          );
                        },
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                6,
                10,
                10,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization:
                          TextCapitalization.sentences,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(
                          color: Colors.white38,
                        ),
                        filled: true,
                        fillColor:
                            Colors.white.withOpacity(.07),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Material(
                      color: pink,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder:
                            const CircleBorder(),
                        onTap:
                            _sending ? null : _send,
                        child: _sending
                            ? const Padding(
                                padding:
                                    EdgeInsets.all(14),
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const _MessageBubble({
    required this.text,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe
        ? const Color(0xFFFF2E93)
        : Colors.white.withOpacity(.08);

    return Align(
      alignment: isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * .78,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft:
                Radius.circular(isMe ? 18 : 5),
            bottomRight:
                Radius.circular(isMe ? 5 : 18),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final double radius;

  const _Avatar({
    required this.name,
    required this.avatarUrl,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim()[0].toUpperCase();

    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFFF2E93),
      backgroundImage: avatarUrl.isNotEmpty
          ? NetworkImage(avatarUrl)
          : null,
      child: avatarUrl.isEmpty
          ? Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            )
          : null,
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.white38,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
