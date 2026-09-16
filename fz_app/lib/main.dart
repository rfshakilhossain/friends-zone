import 'package:flutter/material.dart';

void main() {
  runApp(const FriendsZoneApp());
}

class FriendsZoneApp extends StatelessWidget {
  const FriendsZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friends Zone',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B14),
        primaryColor: const Color(0xFFE040FB),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF131324),
          primary: Color(0xFFE040FB),
          secondary: Color(0xFF7C4DFF),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Feed Screen', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('Radar Screen', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('Games Screen', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('Chats Screen', style: TextStyle(fontSize: 24, color: Colors.white))),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF10101D),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFFE040FB),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.article_rounded), label: 'Feed'),
            BottomNavigationBarItem(icon: Icon(Icons.radar_rounded), label: 'Radar'),
            BottomNavigationBarItem(icon: Icon(Icons.sports_esports_rounded), label: 'Games'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Chats'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
