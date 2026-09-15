import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/user_service.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  @override void initState() { super.initState(); _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(); }
  @override void dispose() { _animationController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F051D), pink = Color(0xFFFF2E93), card = Color(0xFF1A0B2E);
    final currentId = SupabaseService.instance.client.auth.currentUser?.id;
    return Scaffold(backgroundColor: bg, appBar: AppBar(backgroundColor: bg, title: const Text('Zone Radar'), centerTitle: true), body: Column(children: [
      const SizedBox(height: 14),
      SizedBox(height: 250, child: Center(child: RotationTransition(turns: _animationController, child: Container(width: 220, height: 220, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: pink.withOpacity(.45), width: 2), gradient: SweepGradient(colors: [pink.withOpacity(0), pink.withOpacity(.3), pink.withOpacity(0)])), child: const Center(child: Icon(Icons.radar, color: pink, size: 58))))),
      Expanded(child: StreamBuilder<List<Map<String, dynamic>>>(stream: UserService.instance.visibleUsersStream(), builder: (context, snapshot) {
        final users = (snapshot.data ?? const []).where((u) => u['id'] != currentId).toList();
        return ListView.builder(padding: const EdgeInsets.all(16), itemCount: users.length, itemBuilder: (context, i) { final u = users[i]; final name = (u['display_name'] ?? 'Friends Zone User').toString(); return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)), child: Row(children: [CircleAvatar(backgroundColor: pink, child: Text(name.isEmpty ? '?' : name[0].toUpperCase())), const SizedBox(width: 12), Expanded(child: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), Icon(u['is_online'] == true ? Icons.circle : Icons.circle_outlined, color: u['is_online'] == true ? Colors.greenAccent : Colors.white30, size: 12)])); });
      }))
    ]));
  }
}
