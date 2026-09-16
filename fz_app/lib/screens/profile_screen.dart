import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../coin_referral_manager.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    await UserService.instance.setOnline(false);
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F051D);
    const card = Color(0xFF1A0B2E);
    const pink = Color(0xFFFF2E93);
    const gold = Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: const Text('My Profile & Rewards'),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: UserService.instance.currentUserStream(),
        builder: (context, snapshot) {
          final p = snapshot.data ?? const <String, dynamic>{};
          final authUser = Supabase.instance.client.auth.currentUser;

          final name = (p['display_name'] ??
                  authUser?.email?.split('@').first ??
                  'Friends Zone User')
              .toString();

          final email =
              (p['email'] ?? authUser?.email ?? '').toString();

          final avatarUrl = (p['avatar_url'] ?? '').toString();

          return FutureBuilder<List<int>>(
            future: Future.wait<int>([
              CoinReferralManager.getCoins(),
              CoinReferralManager.getReferrals(),
            ]),
            builder: (context, economySnapshot) {
              final economy = economySnapshot.data ?? const [0, 0];
              final tokens = economy[0];
              final referrals = economy[1];

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: pink.withOpacity(.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: pink,
                          backgroundImage: avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: gold.withOpacity(.15),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border:
                                      Border.all(color: gold),
                                ),
                                child: economySnapshot
                                            .connectionState ==
                                        ConnectionState.waiting
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: gold,
                                        ),
                                      )
                                    : Text(
                                        'FZ Tokens: $tokens',
                                        style: const TextStyle(
                                          color: gold,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Referral Rewards',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Total Referrals: $referrals / 100',
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value:
                              (referrals / 100).clamp(0, 1).toDouble(),
                          color: pink,
                          backgroundColor: Colors.white12,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Token and referral rewards are controlled by the trusted backend.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _signOut(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pink,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
