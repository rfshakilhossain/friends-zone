import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();
  static final instance = SupabaseService._();
  SupabaseClient get client => Supabase.instance.client;

  String conversationId(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Stream<List<Map<String, dynamic>>> postsStream() =>
      client.from('posts').stream(primaryKey: ['id']).order('created_at', ascending: false);

  Future<void> createPost({required String caption, String? mediaUrl}) async {
    final user = client.auth.currentUser!;
    await client.from('posts').insert({
      'author_id': user.id,
      'caption': caption.trim(),
      'media_url': mediaUrl,
    });
  }

  Future<void> toggleLike(String postId) async {
    final uid = client.auth.currentUser!.id;
    final existing = await client.from('post_likes').select('post_id').eq('post_id', postId).eq('user_id', uid).maybeSingle();
    if (existing == null) {
      await client.from('post_likes').insert({'post_id': postId, 'user_id': uid});
    } else {
      await client.from('post_likes').delete().eq('post_id', postId).eq('user_id', uid);
    }
  }

  Stream<List<Map<String, dynamic>>> messagesStream(String otherUid) {
    final me = client.auth.currentUser!.id;
    final id = conversationId(me, otherUid);
    return client.from('messages').stream(primaryKey: ['id']).eq('conversation_id', id).order('created_at', ascending: true);
  }

  Future<void> sendMessage({required String otherUid, required String text, String type = 'text', String? mediaUrl}) async {
    final me = client.auth.currentUser!.id;
    final id = conversationId(me, otherUid);
    await client.from('conversations').upsert({
      'id': id,
      'created_by': me,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
      'last_message': text.trim(),
    });
    await client.from('conversation_members').upsert([
      {'conversation_id': id, 'user_id': me},
      {'conversation_id': id, 'user_id': otherUid},
    ], onConflict: 'conversation_id,user_id');
    await client.from('messages').insert({
      'conversation_id': id,
      'sender_id': me,
      'text': text.trim(),
      'type': type,
      'media_url': mediaUrl,
    });
  }

  Future<String> uploadUserFile(String path, List<int> bytes, {String contentType = 'application/octet-stream'}) async {
    final uid = client.auth.currentUser!.id;
    final storagePath = '$uid/$path';
    await client.storage.from('user-files').uploadBinary(storagePath, bytes, fileOptions: FileOptions(contentType: contentType, upsert: true));
    return client.storage.from('user-files').getPublicUrl(storagePath);
  }
}
