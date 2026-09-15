import 'package:shared_preferences/shared_preferences.dart';

class CoinReferralManager {
  // কি-গুলো ফিক্সড রাখা হলো যাতে কোনো টাইপো বা ভুল না হয়
  static const String _keyCoins = 'fz_user_coins';
  static const String _keyReferrals = 'fz_user_referrals';

  // বর্তমান কয়েন ব্যালেন্স রিড করা
  static Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCoins) ?? 1250; // ডিফল্ট স্টার্টিং কয়েন ১২৫০
  }

  // কয়েন যোগ করা (যেমন: গেম জিতলে)
  static Future<int> addCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int currentCoins = await getCoins();
    int newTotal = currentCoins + amount;
    await prefs.setInt(_keyCoins, newTotal);
    return newTotal;
  }

  // কয়েন কেটে নেওয়া (যেমন: প্রিমিয়াম আইটেম আনলক করলে)
  static Future<bool> deductCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int currentCoins = await getCoins();
    if (currentCoins >= amount) {
      int newTotal = currentCoins - amount;
      await prefs.setInt(_keyCoins, newTotal);
      return true; // সফলভাবে কাটা হয়েছে
    }
    return false; // পর্যাপ্ত কয়েন নেই
  }

  // বর্তমান রেফার সংখ্যা রিড করা
  static Future<int> getReferrals() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyReferrals) ?? 12; // ডিফল্ট উদাহরণস্বরূপ ১২ জন রেফার
  }

  // নতুন রেফার যোগ করা (খুঁজে খুঁজে নিখুঁতভাবে ১ করে বাড়বে)
  static Future<int> incrementReferral() async {
    final prefs = await SharedPreferences.getInstance();
    int currentRefs = await getReferrals();
    int newTotal = currentRefs + 1;
    await prefs.setInt(_keyReferrals, newTotal);
    return newTotal;
  }
}
