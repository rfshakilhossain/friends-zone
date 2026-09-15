import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ZoneFeedScreen extends StatefulWidget {
  const ZoneFeedScreen({super.key});
  @override State<ZoneFeedScreen> createState() => _ZoneFeedScreenState();
}

class _ZoneFeedScreenState extends State<ZoneFeedScreen> {
  final _service = SupabaseService.instance;
  final _caption = TextEditingController();

  Future<void> _createPost() async {
    final text = _caption.text.trim();
    if (text.isEmpty) return;
    await _service.createPost(caption: text);
    _caption.clear();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post published')));
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F051D), card = Color(0xFF1A0B2E), pink = Color(0xFFFF2E93), gold = Color(0xFFFFD700);
    return Scaffold(backgroundColor: bg, appBar: AppBar(backgroundColor: bg, title: const Text('Zone Feed & Earn'), actions: const [Padding(padding: EdgeInsets.all(12), child: Icon(Icons.bolt, color: gold))]),
      body: StreamBuilder<List<Map<String, dynamic>>>(stream: _service.postsStream(), builder: (context, snapshot) {
        final posts = snapshot.data ?? const [];
        return ListView(children: [
          Container(margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18), border: Border.all(color: pink.withOpacity(.3))), child: Column(children: [TextField(controller: _caption, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Share something with Friends Zone...', border: InputBorder.none)), Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: _createPost, style: ElevatedButton.styleFrom(backgroundColor: pink), child: const Text('POST')))])),
          if (snapshot.connectionState == ConnectionState.waiting) const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator())),
          if (posts.isEmpty && snapshot.connectionState != ConnectionState.waiting) const Center(child: Padding(padding: EdgeInsets.all(30), child: Text('No posts yet. Be the first to post!'))),
          ...posts.map((p) => _postCard(p, card, pink)),
        ]);
      }));
  }

  Widget _postCard(Map<String, dynamic> p, Color card, Color pink) {
    final media = p['media_url'] as String?;
    return Container(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text((p['author_id'] ?? 'Friends Zone User').toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), Text((p['caption'] ?? '').toString(), style: const TextStyle(color: Colors.white70)),
      if (media != null && media.isNotEmpty) ...[const SizedBox(height: 10), ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.network(media, height: 220, width: double.infinity, fit: BoxFit.cover))],
      Row(children: [IconButton(onPressed: () => _service.toggleLike(p['id'].toString()), icon: const Icon(Icons.favorite_border, color: pink)), const Icon(Icons.chat_bubble_outline, color: Colors.white54), const SizedBox(width: 18), const Icon(Icons.share_outlined, color: Colors.white54)]),
    ]));
  }
  @override void dispose() { _caption.dispose(); super.dispose(); }
}
