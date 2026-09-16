import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

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
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
