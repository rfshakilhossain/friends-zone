import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/supabase_service.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F051D), pink = Color(0xFFFF2E93);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, title: const Text('Chats')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: UserService.instance.visibleUsersStream(),
        builder: (context, snapshot) {
          final currentId = SupabaseService.instance.client.auth.currentUser?.id;
          final users = (snapshot.data ?? const []).where((u) => u['id'] != null && u['id'] != currentId).toList();
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final u = users[i];
              final name = (u['display_name'] ?? 'Friends Zone User').toString();
              return ListTile(
                tileColor: Colors.white.withOpacity(.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                leading: CircleAvatar(backgroundColor: pink, child: Text(name.isEmpty ? '?' : name[0].toUpperCase())),
                title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(u['is_online'] == true ? '🟢 Online' : 'Last seen recently', style: const TextStyle(color: Colors.white54)),
                trailing: const Icon(Icons.chevron_right, color: pink),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userName: name, otherUid: u['id'].toString()))),
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
  const ChatScreen({super.key, required this.userName, this.otherUid});
  @override State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _service = SupabaseService.instance;

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || widget.otherUid == null) return;
    try {
      await _service.sendMessage(otherUid: widget.otherUid!, text: text);
      _messageController.clear();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final otherUid = widget.otherUid;
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      appBar: AppBar(backgroundColor: const Color(0xFF0F051D), title: Row(children: [const CircleAvatar(backgroundColor: Color(0xFFFF2E93), child: Icon(Icons.person)), const SizedBox(width: 10), Text(widget.userName)])),
      body: Column(children: [
        Expanded(child: otherUid == null ? const Center(child: Text('Chat user is not connected yet.')) : StreamBuilder<List<Map<String, dynamic>>>(
          stream: _service.messagesStream(otherUid), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final rows = snapshot.data ?? const [];
            return ListView.builder(padding: const EdgeInsets.all(16), itemCount: rows.length, itemBuilder: (context, i) {
              final m = rows[i];
              final isMe = m['sender_id'] == _service.client.auth.currentUser?.id;
              return Align(alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.symmetric(vertical: 5), padding: const EdgeInsets.all(12), constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .78), decoration: BoxDecoration(color: isMe ? const Color(0xFFFF2E93) : Colors.white.withOpacity(.09), borderRadius: BorderRadius.circular(16)), child: Text((m['text'] ?? '').toString(), style: const TextStyle(color: Colors.white))));
            });
          })),
        Container(padding: const EdgeInsets.all(8), child: Row(children: [Expanded(child: TextField(controller: _messageController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Type a message...', filled: true, fillColor: Colors.white.withOpacity(.06), border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none)))), const SizedBox(width: 6), CircleAvatar(backgroundColor: const Color(0xFFFF2E93), child: IconButton(onPressed: _send, icon: const Icon(Icons.send, color: Colors.white)))])),
      ]),
    );
  }
  @override void dispose() { _messageController.dispose(); super.dispose(); }
}
