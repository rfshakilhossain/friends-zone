import 'package:flutter/foundation.dart';

class SupabaseConfig {
  static const url = String.fromEnvironment('FZ_SUPABASE_URL');
  static const publishableKey = String.fromEnvironment('FZ_SUPABASE_PUBLISHABLE_KEY');

  static void validate() {
    if (url.isEmpty || publishableKey.isEmpty) {
      throw FlutterError(
        'Supabase configuration is missing. Build with '
        '--dart-define=FZ_SUPABASE_URL=... '
        '--dart-define=FZ_SUPABASE_PUBLISHABLE_KEY=...',
      );
    }
  }
}
