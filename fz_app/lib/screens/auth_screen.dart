import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/user_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _login = true;
  bool _loading = false;

  Future<void> _submit() async {
    if (_email.text.trim().isEmpty || _password.text.length < 6 || (!_login && _name.text.trim().isEmpty)) {
      _toast('সঠিক তথ্য দিন। Password কমপক্ষে ৬ অক্ষরের হতে হবে।');
      return;
    }
    setState(() => _loading = true);
    try {
      final auth = Supabase.instance.client.auth;
      if (_login) {
        await auth.signInWithPassword(email: _email.text.trim(), password: _password.text);
      } else {
        final response = await auth.signUp(
          email: _email.text.trim(),
          password: _password.text,
          data: {'display_name': _name.text.trim()},
        );
        if (response.user != null) {
          await UserService.instance.ensureProfile(response.user!, displayName: _name.text.trim());
        }
        if (response.session == null && mounted) {
          _toast('Email confirmation চালু আছে। আপনার email verify করে আবার login করুন।');
        }
      }
    } on AuthException catch (e) {
      _toast(e.message);
    } catch (e) {
      _toast('ত্রুটি: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  void dispose() { _name.dispose(); _email.dispose(); _password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFF2E93);
    return Scaffold(
      body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
        const Text('FRIENDS ZONE', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: pink, letterSpacing: 2)),
        const SizedBox(height: 8),
        Text(_login ? 'Real-time social world' : 'Create your real account', style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 32),
        if (!_login) ...[_field(_name, 'Display name'), const SizedBox(height: 16)],
        _field(_email, 'Email'), const SizedBox(height: 16),
        _field(_password, 'Password', obscure: true), const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: _loading ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: pink, foregroundColor: Colors.white),
          child: _loading ? const CircularProgressIndicator() : Text(_login ? 'LOGIN' : 'CREATE ACCOUNT', style: const TextStyle(fontWeight: FontWeight.bold)))),
        TextButton(onPressed: _loading ? null : () => setState(() => _login = !_login), child: Text(_login ? 'New user? Sign up' : 'Already have an account? Login', style: const TextStyle(color: pink))),
      ])),
    );
  }

  Widget _field(TextEditingController controller, String label, {bool obscure = false}) => TextField(controller: controller, obscureText: obscure, decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white.withOpacity(.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))));
}
