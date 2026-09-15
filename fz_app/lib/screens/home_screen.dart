import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/supabase_service.dart';
import '../services/user_service.dart';
import 'chats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _scanning = false;
  double? _lat, _lon;

  Future<void> _scan() async {
    setState(() => _scanning = true);
    final pos = await LocationService.instance.publishCurrentLocation();
    if (mounted) {
      setState(() { _scanning = false; _lat = pos?.latitude; _lon = pos?.longitude; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pos == null ? 'Location permission/service is unavailable.' : 'Radar location updated.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F051D), pink = Color(0xFFFF2E93);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, elevation: 0, title: const Row(children: [Icon(Icons.radar, color: pink), SizedBox(width: 8), Text('Friends Zone : Nearby', style: TextStyle(color: pink, fontWeight: FontWeight.bold))]), actions: [IconButton(onPressed: _scan, icon: const Icon(Icons.bolt, color: pink))]),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: UserService.instance.visibleUsersStream(),
        builder: (context, snapshot) {
          final currentId = SupabaseService.instance.client.auth.currentUser?.id;
          final all = snapshot.data ?? const [];
          final nearby = all.where((u) {
            if (u['id'] == currentId || _lat == null || _lon == null || u['latitude'] == null || u['longitude'] == null) return false;
            final d = LocationService.distanceKm(_lat!, _lon!, (u['latitude'] as num).toDouble(), (u['longitude'] as num).toDouble());
            return d <= 10;
          }).toList();
          nearby.sort((a, b) => _distance(a).compareTo(_distance(b)));
          return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: pink.withOpacity(.35))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Live Radar Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), SizedBox(height: 4), Text('Showing visible users within 10 km', style: TextStyle(color: Colors.white64, fontSize: 12))]), _scanning ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: pink, strokeWidth: 2)) : ElevatedButton(onPressed: _scan, style: ElevatedButton.styleFrom(backgroundColor: pink), child: const Text('Scan'))]),
            const SizedBox(height: 20),
            const Text('People Around You', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            if (snapshot.connectionState == ConnectionState.waiting) const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_lat == null || _lon == null) const Expanded(child: Center(child: Text('Tap Scan to share your location and find nearby people.')))
            else if (nearby.isEmpty) const Expanded(child: Center(child: Text('No visible nearby users yet.')))
            else Expanded(child: ListView.builder(itemCount: nearby.length, itemBuilder: (context, index) {
              final u = nearby[index];
              final name = (u['display_name'] ?? 'Friends Zone User').toString();
              final d = _distance(u);
              return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black.withOpacity(.3), borderRadius: BorderRadius.circular(14), border: Border.all(color: pink.withOpacity(.2))), child: Row(children: [CircleAvatar(radius: 26, backgroundColor: pink, child: Text(name.isEmpty ? '?' : name[0].toUpperCase())), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text((u['bio'] ?? '').toString().isEmpty ? 'Friends Zone member' : u['bio'].toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)), const SizedBox(height: 4), Text('${d.toStringAsFixed(2)} km away', style: const TextStyle(color: pink, fontSize: 11))])), IconButton(icon: const Icon(Icons.chat_bubble_outline, color: pink), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(userName: name, otherUid: u['id'].toString()))))]));
            })),
          ]));
        },
      ),
    );
  }

  double _distance(Map<String, dynamic> u) => (_lat == null || _lon == null || u['latitude'] == null || u['longitude'] == null) ? double.maxFinite : LocationService.distanceKm(_lat!, _lon!, (u['latitude'] as num).toDouble(), (u['longitude'] as num).toDouble());
}
