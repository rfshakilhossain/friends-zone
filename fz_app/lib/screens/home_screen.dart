import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends Zone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // সার্চ ফাংশনালিটি পরবর্তীতে যুক্ত করা হবে
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // নোটিফিকেশন পরবর্তীতে যুক্ত করা হবে
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // সাময়িকভাবে ১০টি ডেমো পোস্ট দেখানোর জন্য
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ইউজারের প্রোফাইল ইনফো
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'User Name ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // পোস্টের টেক্সট বা ক্যাপশন
                  Text(
                    'This is a sample post update in Friends Zone feed for post number ${index + 1}.',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  // পোস্টের অ্যাকশন বাটন (লাইক, কমেন্ট, শেয়ার)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.favorite_border, color: Colors.grey),
                      Icon(Icons.comment_outlined, color: Colors.grey),
                      Icon(Icons.share_outlined, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
