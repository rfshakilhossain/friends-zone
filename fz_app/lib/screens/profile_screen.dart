class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover Photo & Header
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Image.network('https://picsum.photos/600/220', height: 180, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 40,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () {}),
                  ),
                ),
                Positioned(
                  bottom: -45,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)]),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage('https://picsum.photos/200?random=30'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Arif Hasan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(width: 4),
                Icon(Icons.verified, color: Colors.blue, size: 18),
              ],
            ),
            const Text('@arifhasan', style: TextStyle(fontSize: 12, color: Colors.white54)),
            const SizedBox(height: 6),
            const Text('Dreamer • Traveler • Tech Lover 🌿', style: TextStyle(fontSize: 12, color: Colors.white70)),
            const SizedBox(height: 4),
            const Text('📍 Dhaka, Bangladesh   🟢 Online', style: TextStyle(fontSize: 11, color: Colors.white54)),
            const SizedBox(height: 15),
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Column(children: [Text('1.2K', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)), Text('Followers', style: TextStyle(fontSize: 11, color: Colors.white54))]),
                Column(children: [Text('356', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)), Text('Following', style: TextStyle(fontSize: 11, color: Colors.white54))]),
                Column(children: [Text('48', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)), Text('Posts', style: TextStyle(fontSize: 11, color: Colors.white54))]),
              ],
            ),
            const SizedBox(height: 15),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131324),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // FZ Tokens & Rewards Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF131324),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(children: const [
                      Icon(Icons.monetization_on, color: Colors.amber),
                      SizedBox(width: 8),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('FZ Tokens', style: TextStyle(fontSize: 11, color: Colors.white54)),
                        Text('250 >', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ]),
                    ]),
                    Container(height: 30, width: 1, color: Colors.white12),
                    Row(children: const [
                      Icon(Icons.card_giftcard, color: Color(0xFFE040FB)),
                      SizedBox(width: 8),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Referral Rewards', style: TextStyle(fontSize: 11, color: Colors.white54)),
                        Text('12 / 50', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ]),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Posts Grid View
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                return Image.network('https://picsum.photos/200?random=${index + 40}', fit: BoxFit.cover);
              },
            ),
          ],
        ),
      ),
    );
  }
}
