import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'main_navigation.dart';

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
      // প্রাথমিক রাউট হিসেবে আমরা আপাতত AuthScreen সেট করে রাখছি
      home: const AuthScreen(),
    );
  }
}
