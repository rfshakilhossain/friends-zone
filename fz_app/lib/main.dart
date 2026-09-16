import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const FriendsZoneApp());
}

// ============================================================
// FRIENDS ZONE
// Premium Social App UI Prototype
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
        scaffoldBackgroundColor: const Color(0xFF070711),
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB44CFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// ============================================================
// COLOR SYSTEM
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
// MAIN SCREEN
// ============================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final screens = const [
    HomeScreen(),
    FeedScreen(),
    RadarScreen(),
    GamesScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: screens[currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          decoration: BoxDecoration(
            color: const Color(0xDD11111D),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(.08),
            ),
            boxShadow: [
              BoxShadow(
                color: FZColors.purple.withOpacity(.12),
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
                setState(() => currentIndex = index);
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
                  icon: Icon(Icons.sports_esports_rounded),
                  label: 'Games',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_rounded),
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
                boxShadow: [
                  BoxShadow(
                    color: FZColors.purple.withOpacity(.35),
                    blurRadius: 18,
                  ),
                ],
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
              letterSpacing: -.3,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

// ============================================================
// HOME
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Friends Zone',
        showLogo: true,
        actions: [
          _RoundAction(
            icon: Icons.search_rounded,
            onTap: () {},
          ),
          _RoundAction(
            icon: Icons.notifications_none_rounded,
            badge: true,
            onTap: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: const [
          SizedBox(height: 8),
          WelcomeBanner(),
          SizedBox(height: 22),
          SectionTitle(
            title: 'Stories',
            action: 'See all',
          ),
          SizedBox(height: 12),
          StoryRow(),
          SizedBox(height: 24),
          CreatePostCard(),
          SizedBox(height: 18),
          PremiumPostCard(),
          SizedBox(height: 18),
          PremiumPostCard(
            userName: 'Nusrat Jahan',
            avatar: 'https://i.pravatar.cc/300?img=47',
            image: 'https://picsum.photos/800/500?random=45',
            text: 'Golden hour, good vibes and beautiful memories ✨',
            likes: '1.4K',
            comments: '96',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WELCOME BANNER
// ============================================================

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF281044),
            Color(0xFF17162F),
            Color(0xFF0D2637),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(.08),
        ),
        boxShadow: [
          BoxShadow(
            color: FZColors.purple.withOpacity(.15),
            blurRadius: 30,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Welcome back 👋',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Biplob',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Connect. Share. Enjoy.',
                  style: TextStyle(
                    color: FZColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  FZColors.pink,
                  FZColors.purple,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: FZColors.pink.withOpacity(.35),
                  blurRadius: 25,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STORIES
// ============================================================

class StoryRow extends StatelessWidget {
  const StoryRow({super.key});

  final List<Map<String, String>> stories = const [
    {
      'name': 'Your Story',
      'image': 'https://i.pravatar.cc/300?img=12',
    },
    {
      'name': 'Arif',
      'image': 'https://i.pravatar.cc/300?img=11',
    },
    {
      'name': 'Nusrat',
      'image': 'https://i.pravatar.cc/300?img=47',
    },
    {
      'name': 'Shakil',
      'image': 'https://i.pravatar.cc/300?img=13',
    },
    {
      'name': 'Mim',
      'image': 'https://i.pravatar.cc/300?img=44',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final story = stories[index];

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      FZColors.pink,
                      FZColors.purple,
                      FZColors.cyan,
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 31,
                  backgroundColor: FZColors.surface,
                  backgroundImage: NetworkImage(story['image']!),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                story['name']!,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// CREATE POST
// ============================================================

class CreatePostCard extends StatelessWidget {
  const CreatePostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FZColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage:
                NetworkImage('https://i.pravatar.cc/300?img=12'),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'What’s on your mind?',
              style: TextStyle(
                color: FZColors.muted,
                fontSize: 13,
              ),
            ),
          ),
          _MiniIcon(
            icon: Icons.image_outlined,
            color: FZColors.green,
          ),
          const SizedBox(width: 6),
          _MiniIcon(
            icon: Icons.video_camera_back_outlined,
            color: FZColors.pink,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PREMIUM POST
// ============================================================

class PremiumPostCard extends StatefulWidget {
  final String userName;
  final String avatar;
  final String image;
  final String text;
  final String likes;
  final String comments;

  const PremiumPostCard({
    super.key,
    this.userName = 'Arif Hasan',
    this.avatar = 'https://i.pravatar.cc/300?img=12',
    this.image = 'https://picsum.photos/800/500?random=21',
    this.text = 'Nature always reminds us how beautiful life is... 🌿',
    this.likes = '842',
    this.comments = '67',
  });

  @override
  State<PremiumPostCard> createState() => _PremiumPostCardState();
}

class _PremiumPostCardState extends State<PremiumPostCard> {
  bool liked = false;
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FZColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 25,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  _fadeRoute(
                    UserProfileScreen(
                      userName: widget.userName,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      FZColors.pink,
                      FZColors.purple,
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(widget.avatar),
                ),
              ),
            ),
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  _fadeRoute(
                    UserProfileScreen(
                      userName: widget.userName,
                    ),
                  ),
                );
              },
              child: Text(
                widget.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            subtitle: const Text(
              '2h ago • Public',
              style: TextStyle(
                color: FZColors.muted,
                fontSize: 10,
              ),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz_rounded,
                color: Colors.white54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.network(
              widget.image,
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 5),
            child: Row(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: FZColors.pink,
                  size: 17,
                ),
                const SizedBox(width: 5),
                Text(
                  widget.likes,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.comments} comments',
                  style: const TextStyle(
                    color: FZColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white.withOpacity(.05),
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            child: Row(
              children: [
                Expanded(
                  child: _PostAction(
                    icon: liked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    label: 'Like',
                    active: liked,
                    onTap: () {
                      setState(() => liked = !liked);
                    },
                  ),
                ),
                Expanded(
                  child: _PostAction(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Comment',
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: _PostAction(
                    icon: Icons.send_rounded,
                    label: 'Share',
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: _PostAction(
                    icon: saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    label: 'Save',
                    onTap: () {
                      setState(() => saved = !saved);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF19142D),
                  Color(0xFF101A29),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(.07),
              ),
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
          ),
          const SizedBox(height: 18),
          const PremiumPostCard(),
          const SizedBox(height: 18),
          const PremiumPostCard(
            userName: 'Shakil Hossain',
            avatar: 'https://i.pravatar.cc/300?img=13',
            image: 'https://picsum.photos/800/500?random=66',
            text: 'Weekend vibes with the crew! 🔥',
            likes: '2.1K',
            comments: '148',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 120),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'People Around You',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Discover friends and people nearby',
              style: TextStyle(
                color: FZColors.muted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 310,
              height: 310,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    FZColors.purple.withOpacity(.18),
                    FZColors.purple.withOpacity(.05),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(
                  color: FZColors.purple.withOpacity(.55),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: FZColors.purple.withOpacity(.18),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: FZColors.purple.withOpacity(.18),
                      ),
                    ),
                  ),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: FZColors.purple.withOpacity(.25),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.radar_rounded,
                    size: 75,
                    color: FZColors.purple,
                  ),
                  const Positioned(
                    top: 40,
                    right: 65,
                    child: _RadarDot(
                      color: FZColors.pink,
                    ),
                  ),
                  const Positioned(
                    bottom: 70,
                    left: 48,
                    child: _RadarDot(
                      color: FZColors.cyan,
                    ),
                  ),
                  const Positioned(
                    bottom: 45,
                    right: 60,
                    child: _RadarDot(
                      color: FZColors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              '12 people found nearby',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 16),
                itemBuilder: (_, index) {
                  return const CircleAvatar(
                    radius: 32,
                    backgroundImage:
                        NetworkImage('https://i.pravatar.cc/300?img=15'),
                  );
                },
              ),
            ),
          ],
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
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Zone Games',
      ),
      body: GridView.count(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 120),
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: .92,
        children: const [
          GameCard(
            title: 'Quick Quiz',
            icon: Icons.quiz_rounded,
            subtitle: 'Test your brain',
          ),
          GameCard(
            title: 'Memory',
            icon: Icons.grid_view_rounded,
            subtitle: 'Match the cards',
          ),
          GameCard(
            title: 'Spin Zone',
            icon: Icons.casino_rounded,
            subtitle: 'Spin & play',
          ),
          GameCard(
            title: 'Challenge',
            icon: Icons.bolt_rounded,
            subtitle: 'Beat the score',
          ),
        ],
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1D1732),
            Color(0xFF10101C),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: FZColors.purple.withOpacity(.25),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 28,
            ),
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
// CHATS
// ============================================================

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      ['Shakil Hossain', 'Hello! How are you?', '10:30 AM', '13'],
      ['Nusrat Jahan', 'See you tomorrow ✨', '09:45 AM', '47'],
      ['Arif Hasan', 'That sounds great!', 'Yesterday', '12'],
      ['Mim Akter', 'Sent a photo 📷', 'Yesterday', '44'],
      ['Rahim Ahmed', 'Let’s play a game!', 'Mon', '15'],
    ];

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Messages',
        actions: [
          _RoundAction(
            icon: Icons.edit_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 120),
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 5),
        itemBuilder: (context, index) {
          final user = users[index];

          return Container(
            decoration: BoxDecoration(
              color: FZColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(.04),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 5,
              ),
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundImage:
                        NetworkImage('https://i.pravatar.cc/300?img=${user[3]}'),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: FZColors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: FZColors.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                user[0],
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                user[1],
                style: const TextStyle(
                  color: FZColors.muted,
                  fontSize: 11,
                ),
              ),
              trailing: Text(
                user[2],
                style: const TextStyle(
                  color: FZColors.muted,
                  fontSize: 9,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  _fadeRoute(
                    ChatScreen(userName: user[0]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// CHAT WINDOW
// ============================================================

class ChatScreen extends StatelessWidget {
  final String userName;

  const ChatScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FZColors.background,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 19,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/300?img=13'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 10,
                    color: FZColors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ChatBubble(
                  text: 'Hello! How are you?',
                  mine: false,
                ),
                ChatBubble(
                  text: 'I am good! What about you? 😊',
                  mine: true,
                ),
                ChatBubble(
                  text: 'Doing great! Welcome to Friends Zone.',
                  mine: false,
                ),
              ],
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: FZColors.surface2,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(.06),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      color: FZColors.purple,
                    ),
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: FZColors.muted,
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mic_none_rounded,
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          FZColors.purple,
                          FZColors.pink,
                        ],
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.send_rounded),
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

class ChatBubble extends StatelessWidget {
  final String text;
  final bool mine;

  const ChatBubble({
    super.key,
    required this.text,
    required this.mine,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          gradient: mine
              ? const LinearGradient(
                  colors: [
                    FZColors.purple,
                    FZColors.pink,
                  ],
                )
              : null,
          color: mine ? null : FZColors.surface2,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
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
      appBar: PremiumAppBar(
        title: 'My Profile',
        actions: [
          _RoundAction(
            icon: Icons.settings_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://picsum.photos/900/400?random=100',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -48),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          FZColors.pink,
                          FZColors.purple,
                          FZColors.cyan,
                        ],
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 48,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/300?img=12'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Biplob Hossain Billal',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '@biplob',
                    style: TextStyle(
                      color: FZColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Creator • Explorer • Friends Zone',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: const [
                      ProfileStat(
                        number: '248',
                        label: 'Friends',
                      ),
                      ProfileStat(
                        number: '12.4K',
                        label: 'Followers',
                      ),
                      ProfileStat(
                        number: '386',
                        label: 'Posts',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit_rounded,
                            size: 17,
                          ),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FZColors.purple,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: FZColors.surface2,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share_rounded,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// USER PROFILE
// ============================================================

class UserProfileScreen extends StatelessWidget {
  final String userName;

  const UserProfileScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        backgroundColor: FZColors.background,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/300?img=11'),
            ),
            const SizedBox(height: 15),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '@friendszone_user',
              style: TextStyle(
                color: FZColors.muted,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: FZColors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Friend'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SMALL COMPONENTS
// ============================================================

class SectionTitle extends StatelessWidget {
  final String title;
  final String action;

  const SectionTitle({
    super.key,
    required this.title,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        Text(
          action,
          style: const TextStyle(
            color: FZColors.purple,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RoundAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool badge;

  const _RoundAction({
    required this.icon,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: FZColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(.06),
              ),
            ),
            child: Icon(
              icon,
              size: 19,
            ),
          ),
        ),
        if (badge)
          Positioned(
            right: 7,
            top: 7,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: FZColors.pink,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _MiniIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _MiniIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 18,
      ),
    );
  }
}

class _PostAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PostAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Column(
          children: [
            Icon(
              icon,
              size: 19,
              color: active
                  ? FZColors.pink
                  : Colors.white60,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String number;
  final String label;

  const ProfileStat({
    super.key,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: FZColors.muted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _RadarDot extends StatelessWidget {
  final Color color;

  const _RadarDot({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.7),
            blurRadius: 14,
            spreadRadius: 4,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PAGE TRANSITION
// ============================================================

PageRouteBuilder _fadeRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, animation, __) => page,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(.04, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: child,
        ),
      );
    },
  );
}
