import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation.dart';
import 'services/user_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SupabaseConfig.validate();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F051D),
        primaryColor: const Color(0xFFFF2E93),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF2E93),
          secondary: Color(0xFFFFD700),
          surface: Color(0xFF1A0B2E),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;
        if (snapshot.connectionState == ConnectionState.waiting && session == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = session?.user;
        if (user == null) return const AuthScreen();
        UserService.instance.ensureProfile(user);
        return const MainNavigation();
      },
    );
  }
}
