import 'package:flutter/material.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: () {
              // পোস্ট পাবলিশ করার লজিক পরবর্তীতে যুক্ত হবে
              Navigator.pop(context);
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ইউজারের তথ্য
            const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text(
                  'Biplob Hossain Billal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // লেখার টেক্সট ফিল্ড
            const Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'What is on your mind in Friends Zone?',
                  border: InputBorder.none,
                ),
              ),
            ),
            // মিডিয়া বা ছবি যুক্ত করার অপশন বার
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade800, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.deepPurple),
                    onPressed: () {
                      // গ্যালারি থেকে ছবি তোলার লজিক
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.deepPurple),
                    onPressed: () {
                      // ক্যামেরা ব্যবহারের লজিক
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions, color: Colors.deepPurple),
                    onPressed: () {
                      // ইমোজি যুক্ত করার লজিক
                    },
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

