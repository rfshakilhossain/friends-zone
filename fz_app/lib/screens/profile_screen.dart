import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // সেটিংস অপশন পরবর্তীতে যুক্ত করা হবে
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // প্রোফাইল পিকচার
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 12),
            // ইউজারের নাম
            const Text(
              'Biplob Hossain Billal',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // ইউজার বায়ো বা স্ট্যাটাস
            const Text(
              'Exploring Friends Zone & Connecting people.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            // ফলোয়ার, ফলোয়িং এবং পোস্ট কাউন্টার সেকশন
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('150', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Posts', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Column(
                  children: [
                    Text('1.2K', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Followers', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Column(
                  children: [
                    Text('340', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Following', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // এডিট প্রোফাইল বাটন
            ElevatedButton(
              onPressed: () {
                // এডিট প্রোফাইল লজিক পরবর্তীতে যুক্ত হবে
              },
              child: const Text('Edit Profile'),
            ),
            const Divider(height: 40, thickness: 1),
            // ইউজারের পোস্টগুলোর গ্রিড ভিউ (Placeholder Grid)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 9, // সাময়িকভাবে ৯টি ছবি দেখানোর জন্য
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[500],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
