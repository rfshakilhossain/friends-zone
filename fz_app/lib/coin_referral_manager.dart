import 'package:supabase_flutter/supabase_flutter.dart';

/// Read-only client facade for the Friends Zone economy.
///
/// Token/referral mutations are intentionally not exposed here. Economy writes
/// must happen through trusted server-side code so a modified client cannot
/// manufacture tokens or referrals.
class CoinReferralManager {
  CoinReferralManager._();

  static final SupabaseClient _client = Supabase.instance.client;

  static Future<int> getCoins() async {
    final response = await _client.rpc('get_my_token_balance');
    return (response as num?)?.toInt() ?? 0;
  }

  static Future<int> getReferrals() async {
    final response = await _client.rpc('get_my_referral_count');
    return (response as num?)?.toInt() ?? 0;
  }

  static Future<int> addCoins(int amount) async {
    throw StateError(
      'Token mutations must be performed by the trusted backend.',
    );
  }

  static Future<bool> deductCoins(int amount) async {
    throw StateError(
      'Token mutations must be performed by the trusted backend.',
    );
  }

  static Future<int> incrementReferral() async {
    throw StateError(
      'Referral mutations must be performed by the trusted backend.',
    );
  }
}
