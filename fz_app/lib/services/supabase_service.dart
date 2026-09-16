import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static final instance = SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  User? get currentUser => client.auth.currentUser;

  String conversationId(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  // ==========================================================
  // POSTS
  // ==========================================================

  Stream<List<Map<String, dynamic>>> postsStream() {
    return client
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  Future<void> createPost({
    required String caption,
    String? mediaUrl,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw StateError('You must be signed in to create a post.');
    }

    final cleanCaption = caption.trim();

    if (cleanCaption.isEmpty && (mediaUrl == null || mediaUrl.isEmpty)) {
      throw ArgumentError('Post cannot be empty.');
    }

    await client.from('posts').insert({
      'author_id': user.id,
      'caption': cleanCaption,
      'media_url': mediaUrl,
    });
  }

  Future<bool> hasLiked(String postId) async {
    final user = currentUser;

    if (user == null) return false;

    final result = await client
        .from('post_likes')
        .select('post_id')
        .eq('post_id', postId)
        .eq('user_id', user.id)
        .maybeSingle();

    return result != null;
  }

  Future<void> toggleLike(String postId) async {
    final user = currentUser;

    if (user == null) {
      throw StateError('You must be signed in to like a post.');
    }

    final existing = await client
        .from('post_likes')
        .select('post_id')
        .eq('post_id', postId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (existing == null) {
      await client.from('post_likes').insert({
        'post_id': postId,
        'user_id': user.id,
      });
    } else {
      await client
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', user.id);
    }
  }

  Stream<List<Map<String, dynamic>>> postLikesStream(String postId) {
    return client
        .from('post_likes')
        .stream(primaryKey: ['post_id', 'user_id'])
        .eq('post_id', postId);
  }

  Stream<List<Map<String, dynamic>>> commentsStream(String postId) {
    return client
        .from('post_comments')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at', ascending: true);
  }

  Future<void> addComment({
    required String postId,
    required String body,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw StateError('You must be signed in to comment.');
    }

    final cleanBody = body.trim();

    if (cleanBody.isEmpty) {
      throw ArgumentError('Comment cannot be empty.');
    }

    await client.from('post_comments').insert({
      'post_id': postId,
      'user_id': user.id,
      'body': cleanBody,
    });
  }

  // ==========================================================
  // CHAT
  // ==========================================================

  Stream<List<Map<String, dynamic>>> messagesStream(String otherUid) {
    final me = currentUser?.id;

    if (me == null) {
      return const Stream.empty();
    }

    final id = conversationId(me, otherUid);

    return client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', id)
        .order('created_at', ascending: true);
  }

  Future<void> ensureConversation(String otherUid) async {
    final me = currentUser;

    if (me == null) {
      throw StateError('You must be signed in to start a conversation.');
    }

    if (me.id == otherUid) {
      throw ArgumentError('You cannot start a conversation with yourself.');
    }

    final id = conversationId(me.id, otherUid);

    final existing = await client
        .from('conversations')
        .select('id')
        .eq('id', id)
        .maybeSingle();

    if (existing == null) {
      await client.from('conversations').insert({
        'id': id,
        'created_by': me.id,
        'last_message': '',
      });
    }

    final existingMembers = await client
        .from('conversation_members')
        .select('user_id')
        .eq('conversation_id', id);

    final memberIds = (existingMembers as List)
        .map((row) => row['user_id']?.toString())
        .whereType<String>()
        .toSet();

    if (!memberIds.contains(me.id)) {
      await client.from('conversation_members').insert({
        'conversation_id': id,
        'user_id': me.id,
      });
    }

    if (!memberIds.contains(otherUid)) {
      await client.from('conversation_members').insert({
        'conversation_id': id,
        'user_id': otherUid,
      });
    }
  }

  Future<void> sendMessage({
    required String otherUid,
    required String text,
    String type = 'text',
    String? mediaUrl,
  }) async {
    final me = currentUser;

    if (me == null) {
      throw StateError('You must be signed in to send messages.');
    }

    final cleanText = text.trim();

    if (cleanText.isEmpty && (mediaUrl == null || mediaUrl.isEmpty)) {
      throw ArgumentError('Message cannot be empty.');
    }

    await ensureConversation(otherUid);

    final id = conversationId(me.id, otherUid);
    final now = DateTime.now().toUtc().toIso8601String();

    await client.from('messages').insert({
      'conversation_id': id,
      'sender_id': me.id,
      'text': cleanText,
      'type': type,
      'media_url': mediaUrl,
      'created_at': now,
    });

    await client
        .from('conversations')
        .update({
          'last_message': cleanText,
          'updated_at': now,
        })
        .eq('id', id);
  }

  // ==========================================================
  // STORAGE
  // ==========================================================

  Future<String> uploadUserFile(
    String path,
    List<int> bytes, {
    String contentType = 'application/octet-stream',
  }) async {
    final user = currentUser;

    if (user == null) {
      throw StateError('You must be signed in to upload files.');
    }

    final cleanPath = path
        .replaceAll('\\', '/')
        .replaceFirst(RegExp(r'^/+'), '');

    if (cleanPath.isEmpty) {
      throw ArgumentError('File path cannot be empty.');
    }

    final storagePath = '${user.id}/$cleanPath';

    await client.storage.from('user-files').uploadBinary(
          storagePath,
          bytes,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: true,
          ),
        );

    return client.storage.from('user-files').createSignedUrl(
          storagePath,
          3600,
        );
  }
}
