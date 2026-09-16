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

// --- Main Screen with Bottom Navigation ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FeedScreen(),
    const RadarScreen(),
    const GamesScreen(),
    const ChatsScreen(),
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

// --- 1. Home Screen ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B14),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('FZ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(width: 8),
            const Text('Friends Zone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          // Post Card with Tap to User Profile
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF131324),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileScreen(userName: 'Arif Hasan')));
                      },
                      child: const CircleAvatar(backgroundImage: NetworkImage('https://picsum.photos/200?random=20')),
                    ),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileScreen(userName: 'Arif Hasan')));
                      },
                      child: const Text('Arif Hasan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    subtitle: const Text('2h ago • 🌐', style: TextStyle(fontSize: 11, color: Colors.white54)),
                    trailing: const Icon(Icons.more_horiz, color: Colors.white54),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Nature always reminds us how beautiful life is... 🌿', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  const SizedBox(height: 10),
                  Image.network('https://picsum.photos/600/350', height: 220, width: double.infinity, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Row(children: [Icon(Icons.favorite, color: Colors.pink, size: 18), SizedBox(width: 4), Text('842', style: TextStyle(fontSize: 12))]),
                        Row(children: [Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 18), SizedBox(width: 4), Text('67', style: TextStyle(fontSize: 12))]),
                        Icon(Icons.bookmark_border, color: Colors.white54, size: 18),
                      ],
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
}

// --- 2. Feed Screen ---
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Feed')),
      body: const Center(child: Text('All Public Feeds & Articles', style: TextStyle(color: Colors.white54))),
    );
  }
}

// --- 3. Radar Screen (People Around You) ---
class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Radar - Friends Zone')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE040FB), width: 2),
                color: const Color(0xFF131324),
              ),
              child: const Center(
                child: Icon(Icons.radar, size: 80, color: Color(0xFFE040FB)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Searching for people around you...', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

// --- 4. Games Screen ---
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zone Games')),
      body: const Center(child: Text('Exciting Mini Games Coming Soon!', style: TextStyle(color: Colors.white54))),
    );
  }
}

// --- 5. Chats Screen ---
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(backgroundImage: NetworkImage('https://picsum.photos/200?random=50')),
            title: const Text('Shakil Hossain', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Hello! How are you?', style: TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: const Text('10:30 AM', style: TextStyle(color: Colors.white38, fontSize: 10)),
            onTap: () {
              // Open Chat Window
            },
          );
        },
      ),
    );
  }
}

// --- 6. Profile Screen ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 20),
            CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://picsum.photos/200?random=30')),
            SizedBox(height: 10),
            Text('Biplob Hossain Billal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('@biplob', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// --- Dynamic User Profile View (When clicking any post user) ---
class UserProfileScreen extends StatelessWidget {
  final String userName;
  const UserProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userName)),
      body: Center(
        child: Text('$userName Profile Details', style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
