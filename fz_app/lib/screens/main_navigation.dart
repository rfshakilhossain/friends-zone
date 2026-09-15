import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'discover_screen.dart'; // এটি আমাদের Zone Radar
import 'games_screen.dart';
import 'chats_screen.dart';
import 'profile_screen.dart';
import 'zone_feed_screen.dart'; // নতুন Zone Feed স্ক্রিন
import '../services/location_service.dart';
import '../services/user_service.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    UserService.instance.setOnline(true);
    LocationService.instance.publishCurrentLocation();
  }

  @override
  void dispose() {
    UserService.instance.setOnline(false);
    super.dispose();
  }

  // অ্যাপের মূল স্ক্রিনগুলোর তালিকা (এখানে Zone Feed যুক্ত করা হয়েছে)
  final List<Widget> _screens = [
    const HomeScreen(),
    const ZoneFeedScreen(), // নতুন ফিড ট্যাব
    const DiscoverScreen(), // Zone Radar
    const GamesScreen(),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFF0F051D);
    const Color neonPink = Color(0xFFFF2E93);
    const Color cardColor = Color(0xFF1A0B2E);

    return Scaffold(
      backgroundColor: bgColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            top: BorderSide(color: neonPink.withOpacity(0.3), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: neonPink,
          unselectedItemColor: Colors.white54,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dynamic_feed_outlined),
              activeIcon: Icon(Icons.dynamic_feed),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radar_outlined),
              activeIcon: Icon(Icons.radar),
              label: 'Radar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports_outlined),
              activeIcon: Icon(Icons.sports_esports),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
