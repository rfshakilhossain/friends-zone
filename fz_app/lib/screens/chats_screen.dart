import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // চ্যাট সার্চ লজিক
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 8, // সাময়িকভাবে ৮টি চ্যাট কনভার্সেশন দেখানোর জন্য
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              'Friend Name ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Hello! How are you doing in Friends Zone?',
              style: TextStyle(color: Colors.grey.shade400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Text(
              '10:30 AM',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              // নির্দিষ্ট চ্যাট উইন্ডোতে যাওয়ার লজিক পরবর্তীতে যুক্ত হবে
            },
          );
        },
      ),
    );
  }
}
