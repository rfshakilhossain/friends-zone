import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // সাময়িকভাবে কিছু চ্যাট কনট্যাক্টের ডামি লিস্ট
    final List<Map<String, String>> chatUsers = [
      {'name': 'Shakil Hossain', 'lastMessage': 'Hello! How are you?', 'time': '10:30 AM'},
      {'name': 'Rahim Ahmed', 'lastMessage': 'Let\'s catch up tomorrow.', 'time': '9:15 AM'},
      {'name': 'Nusrat Jahan', 'lastMessage': 'Sent a photo.', 'time': 'Yesterday'},
      {'name': 'Tanvir Hasan', 'lastMessage': 'Thanks for the help!', 'time': '2 days ago'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: chatUsers.length,
        itemBuilder: (context, index) {
          final user = chatUsers[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              user['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              user['lastMessage']!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              user['time']!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              // চ্যাট আইটেমে ক্লিক করলে নির্দিষ্ট চ্যাট ডিটেইল স্ক্রিনে নিয়ে যাবে
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    friendName: user['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
