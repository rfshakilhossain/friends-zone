import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ডামি পোস্টের ডেটা লিস্ট, যেখানে লাইক এবং কমেন্ট স্টেট রাখা হয়েছে
  final List<Map<String, dynamic>> _posts = [
    {
      'name': 'Shakil Hossain',
      'time': '2 hours ago',
      'content': 'Exploring the wonderful features of our new Flutter social app, Friends Zone! 🚀',
      'likes': 15,
      'isLiked': false,
      'comments': ['Looks amazing!', 'Great work on the UI!'],
    },
    {
      'name': 'Rahim Ahmed',
      'time': '5 hours ago',
      'content': 'Beautiful weather today in Ishwardi. Enjoying coding with Flutter! 💻✨',
      'likes': 28,
      'isLiked': true,
      'comments': ['Awesome!', 'Keep it up!'],
    },
    {
      'name': 'Nusrat Jahan',
      'time': '1 day ago',
      'content': 'Just published a new update. Everything is running so smoothly.',
      'likes': 42,
      'isLiked': false,
      'comments': ['Very nice!'],
    },
  ];

  // লাইক টগল করার ফাংশন
  void _toggleLike(int index) {
    setState(() {
      final post = _posts[index];
      if (post['isLiked'] == true) {
        post['isLiked'] = false;
        post['likes'] -= 1;
      } else {
        post['isLiked'] = true;
        post['likes'] += 1;
      }
    });
  }

  // কমেন্ট দেখার বা যোগ করার বটম শিট ওপেন করার ফাংশন
  void _openComments(int index) {
    final TextEditingController commentController = TextEditingController();
    final post = _posts[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SizedBox(
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Divider(color: Colors.grey),
                Expanded(
                  child: ListView.builder(
                    itemCount: (post['comments'] as List).length,
                    itemBuilder: (context, cIndex) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.person, size: 18, color: Colors.white),
                        ),
                        title: Text(
                          post['comments'][cIndex],
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[850],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.deepPurpleAccent),
                      onPressed: () {
                        if (commentController.text.trim().isNotEmpty) {
                          setState(() {
                            post['comments'].add(commentController.text.trim());
                          });
                          commentController.clear();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // শেয়ার করার ফাংশন
  void _sharePost(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post link copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends Zone Feed'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          final isLiked = post['isLiked'] as bool;
          final likesCount = post['likes'] as int;
          final commentsCount = (post['comments'] as List).length;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // পোস্ট হেডার (প্রোফাইল ছবি ও নাম)
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            post['time'],
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // পোস্টের মূল টেক্সট
                  Text(
                    post['content'],
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  
                  // লাইক, কমেন্ট ও শেয়ার বাটন বার
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // লাইক বাটন
                      TextButton.icon(
                        onPressed: () => _toggleLike(index),
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        label: Text(
                          '$likesCount',
                          style: TextStyle(color: isLiked ? Colors.red : Colors.grey),
                        ),
                      ),
                      
                      // কমেন্ট বাটন
                      TextButton.icon(
                        onPressed: () => _openComments(index),
                        icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                        label: Text(
                          '$commentsCount',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      
                      // শেয়ার বাটন
                      TextButton.icon(
                        onPressed: () => _sharePost(context),
                        icon: const Icon(Icons.share_outlined, color: Colors.grey),
                        label: const Text(
                          'Share',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
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
