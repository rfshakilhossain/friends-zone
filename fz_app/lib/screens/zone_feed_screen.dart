import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class ZoneFeedScreen extends StatefulWidget {
  const ZoneFeedScreen({super.key});

  @override
  State<ZoneFeedScreen> createState() => _ZoneFeedScreenState();
}

class _ZoneFeedScreenState extends State<ZoneFeedScreen> {
  final SupabaseService _service = SupabaseService.instance;
  final TextEditingController _caption = TextEditingController();

  bool _posting = false;

  Future<void> _createPost() async {
    final text = _caption.text.trim();

    if (text.isEmpty || _posting) {
      return;
    }

    setState(() {
      _posting = true;
    });

    try {
      await _service.createPost(caption: text);

      _caption.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post published'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to publish post. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _posting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F051D);
    const card = Color(0xFF1A0B2E);
    const pink = Color(0xFFFF2E93);
    const gold = Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('Zone Feed & Earn'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.bolt,
              color: gold,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _service.postsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ErrorView(
              onRetry: () {
                setState(() {});
              },
            );
          }

          final posts = snapshot.data ?? const [];

          return ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              _Composer(
                controller: _caption,
                posting: _posting,
                onPost: _createPost,
              ),
              if (snapshot.connectionState ==
                  ConnectionState.waiting)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (posts.isEmpty &&
                  snapshot.connectionState !=
                      ConnectionState.waiting)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      'No posts yet.\nBe the first to post!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ...posts.map(
                (post) => _PostCard(
                  post: post,
                  card: card,
                  pink: pink,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool posting;
  final VoidCallback onPost;

  const _Composer({
    required this.controller,
    required this.posting,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF1A0B2E);
    const pink = Color(0xFFFF2E93);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: pink.withValues(alpha: .3),
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              hintText:
                  'Share something with Friends Zone...',
              hintStyle: TextStyle(
                color: Colors.white38,
              ),
              border: InputBorder.none,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: posting ? null : onPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
              ),
              child: posting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('POST'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final Color card;
  final Color pink;

  const _PostCard({
    required this.post,
    required this.card,
    required this.pink,
  });

  @override
  Widget build(BuildContext context) {
    final media = post['media_url']?.toString();
    final caption = (post['caption'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (post['author_id'] ??
                    'Friends Zone User')
                .toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            caption,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          if (media != null && media.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                media,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const SizedBox(
                  height: 220,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white38,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final id = post['id']?.toString();

                  if (id == null || id.isEmpty) {
                    return;
                  }

                  try {
                    await SupabaseService.instance
                        .toggleLike(id);
                  } catch (_) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Unable to update like.',
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.favorite_border,
                  color: pink,
                ),
              ),
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white54,
              ),
              const SizedBox(width: 18),
              const Icon(
                Icons.share_outlined,
                color: Colors.white54,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({
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
              size: 44,
              color: Colors.white38,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load the Zone Feed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
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
