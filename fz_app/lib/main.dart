import 'package:flutter/material.dart';

void main() {
  runApp(const FriendsZoneApp());
}

class FriendsZoneApp extends StatelessWidget {
  const FriendsZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friends Zone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const PlaceholderScreen(),
    );
  }
}

// সাময়িক প্লেসহোল্ডার স্ক্রিন, পরবর্তীতে এখানে আমরা মূল হোম/ফিড স্ক্রিন যুক্ত করব
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends Zone'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Friends Zone',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
