import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  UserService._();

  static final instance = UserService._();

  final _client = Supabase.instance.client;

  Future<void> ensureProfile(
    User user, {
    String? displayName,
  }) async {
    final existing = await _client
        .from('profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (existing == null) {
      await _client.rpc(
        'ensure_my_profile',
        params: {
          'p_display_name': (displayName ??
                  user.userMetadata?['display_name'] ??
                  user.email?.split('@').first ??
                  'Friends Zone User')
              .toString()
              .trim(),
          'p_email': user.email,
          'p_avatar_url': user.userMetadata?['avatar_url'],
        },
      );
    }

    await setOnline(true);
  }

  Future<void> setOnline(bool value) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final now = DateTime.now().toUtc().toIso8601String();

    await _client.from('profiles').update({
      'is_online': value,
      'last_seen': now,
      'updated_at': now,
    }).eq('id', user.id);
  }

  Future<void> updateLocation(
    double latitude,
    double longitude,
  ) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final now = DateTime.now().toUtc().toIso8601String();

    await _client.from('profiles').update({
      'latitude': latitude,
      'longitude': longitude,
      'location_updated_at': now,
      'updated_at': now,
    }).eq('id', user.id);
  }

  Stream<Map<String, dynamic>?> currentUserStream() {
    final user = _client.auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', user.id)
        .map((rows) => rows.isEmpty ? null : rows.first);
  }

  Stream<List<Map<String, dynamic>>> visibleUsersStream() {
    return _client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('visibility', true)
        .order('is_online', ascending: false);
  }

  Future<List<Map<String, dynamic>>> nearbyUsers({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    final rows = await _client.rpc(
      'nearby_visible_profiles',
      params: {
        'p_latitude': latitude,
        'p_longitude': longitude,
        'p_radius_km': radiusKm,
      },
    );

    return (rows as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList(growable: false);
  }

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
    bool? visibility,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final data = <String, dynamic>{
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    if (displayName != null) {
      data['display_name'] = displayName.trim();
    }

    if (bio != null) {
      data['bio'] = bio.trim();
    }

    if (avatarUrl != null) {
      data['avatar_url'] = avatarUrl;
    }

    if (visibility != null) {
      data['visibility'] = visibility;
    }

    await _client.from('profiles').update(data).eq('id', user.id);
  }
}
