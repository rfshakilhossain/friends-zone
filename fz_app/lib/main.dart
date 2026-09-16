import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'screens/chats_screen.dart';

// ============================================================
// FRIENDS ZONE
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl =
      String.fromEnvironment('FZ_SUPABASE_URL');

  const supabasePublishableKey =
      String.fromEnvironment(
    'FZ_SUPABASE_PUBLISHABLE_KEY',
  );

  if (supabaseUrl.isEmpty ||
      supabasePublishableKey.isEmpty) {
    throw StateError(
      'Missing Supabase configuration. '
      'FZ_SUPABASE_URL and FZ_SUPABASE_PUBLISHABLE_KEY '
      'must be provided with --dart-define.',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabasePublishableKey,
  );

  runApp(const FriendsZoneApp());
}

// ============================================================
// APP
// ============================================================

class FriendsZoneApp extends StatelessWidget {
  const FriendsZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friends Zone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: FZColors.background,
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FZColors.purple,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// ============================================================
// COLORS
// ============================================================

class FZColors {
  static const background = Color(0xFF070711);
  static const surface = Color(0xFF11111D);
  static const surface2 = Color(0xFF171725);

  static const purple = Color(0xFFB44CFF);
  static const violet = Color(0xFF7048FF);
  static const pink = Color(0xFFFF4FD8);
  static const cyan = Color(0xFF31D7FF);
  static const green = Color(0xFF35E89A);

  static const text = Colors.white;
  static const muted = Color(0xFF9B9BAA);
}

// ============================================================
// MAIN NAVIGATION
// ============================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = const [
      HomeScreen(),
      FeedScreen(),
      RadarScreen(),
      GamesScreen(),
      ChatsScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(
            12,
            0,
            12,
            12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xDD11111D),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: .08),
            ),
            boxShadow: [
              BoxShadow(
                color: FZColors.purple.withValues(alpha: .12),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: FZColors.purple,
              unselectedItemColor: FZColors.muted,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_rounded),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.radar_rounded),
                  label: 'Radar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.sports_esports_rounded,
                  ),
                  label: 'Games',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_bubble_rounded,
                  ),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PREMIUM APP BAR
// ============================================================

class PremiumAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final List<Widget>? actions;

  const PremiumAppBar({
    super.key,
    required this.title,
    this.showLogo = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 18,
      title: Row(
        children: [
          if (showLogo) ...[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    FZColors.purple,
                    FZColors.pink,
                  ],
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Center(
                child: Text(
                  'FZ',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(70);
}

// ============================================================
// FEED
// ============================================================

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Explore',
        actions: [
          _RoundAction(
            icon: Icons.tune_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          120,
        ),
        children: const [
          SizedBox(height: 12),
          _DiscoverBanner(),
          SizedBox(height: 18),
          _DemoPostCard(
            userName: 'Arif Hasan',
            text:
                'Nature always reminds us how beautiful life is... 🌿',
          ),
          SizedBox(height: 18),
          _DemoPostCard(
            userName: 'Shakil Hossain',
            text:
                'Weekend vibes with the crew! 🔥',
          ),
        ],
      ),
    );
  }
}

class _DiscoverBanner extends StatelessWidget {
  const _DiscoverBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF19142D),
            Color(0xFF101A29),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: FZColors.purple,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Discover posts, creators and trending moments.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoPostCard extends StatelessWidget {
  final String userName;
  final String text;

  const _DemoPostCard({
    required this.userName,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FZColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RADAR
// ============================================================

class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Live Radar',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: FZColors.purple
                        .withValues(alpha: .5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: FZColors.purple
                          .withValues(alpha: .15),
                      blurRadius: 50,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.radar_rounded,
                    size: 90,
                    color: FZColors.purple,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Use Home → Scan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your real nearby-user radar is connected to Supabase.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FZColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GAMES
// ============================================================

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      ['Quick Quiz', 'Test your brain', Icons.quiz_rounded],
      ['Memory', 'Match the cards', Icons.grid_view_rounded],
      ['Spin Zone', 'Spin & play', Icons.casino_rounded],
      ['Challenge', 'Beat the score', Icons.bolt_rounded],
    ];

    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Zone Games',
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          120,
        ),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: .92,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          return GameCard(
            title: games[index][0] as String,
            subtitle: games[index][1] as String,
            icon: games[index][2] as IconData,
          );
        },
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const GameCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1D1732),
            Color(0xFF10101C),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  FZColors.purple,
                  FZColors.pink,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(17),
            ),
            child: Icon(icon, size: 28),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: FZColors.muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'My Profile',
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: FZColors.surface,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person_rounded,
                  size: 50,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Friends Zone Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SMALL WIDGETS
// ============================================================

class _RoundAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundAction({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: FZColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 19,
        ),
      ),
    );
  }
}
