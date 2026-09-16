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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text('FZ 250', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(width: 4),
                Icon(Icons.add_circle, color: Color(0xFFE040FB), size: 16),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stories Section
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)]),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(2.5),
                                  child: CircleAvatar(backgroundColor: Color(0xFF131324)),
                                ),
                              ),
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Color(0xFFE040FB),
                                  child: Icon(Icons.add, size: 14, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text('My Story', style: TextStyle(fontSize: 11, color: Colors.white70)),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)]),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.5),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage('https://picsum.photos/200?random=$index'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('User $index', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white12),
            // Post Creator Box
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF131324),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://picsum.photos/200?random=10')),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B1B30),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Share something with Friends Zone...', style: TextStyle(color: Colors.white54, fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Row(children: [Icon(Icons.image, color: Colors.green, size: 18), SizedBox(width: 4), Text('Photo', style: TextStyle(fontSize: 12))]),
                        Row(children: [Icon(Icons.videocam, color: Colors.pink, size: 18), SizedBox(width: 4), Text('Video', style: TextStyle(fontSize: 12))]),
                        Row(children: [Icon(Icons.emoji_emotions, color: Colors.amber, size: 18), SizedBox(width: 4), Text('Feeling', style: TextStyle(fontSize: 12))]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Post Card Example
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      leading: const CircleAvatar(backgroundImage: NetworkImage('https://picsum.photos/200?random=20')),
                      title: const Text('Arif Hasan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: const Text('2h ago • 🌐', style: TextStyle(fontSize: 11, color: Colors.white54)),
                      trailing: const Icon(Icons.more_horiz, color: Colors.white54),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Nature always reminds us how beautiful life is... 🌿', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Image.network('https://picsum.photos/600/350', height: 220, width: double.infinity, fit: BoxFit.cover),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                            child: const Text('1/4', style: TextStyle(fontSize: 10, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
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
      ),
    );
  }
}
