import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_model.dart';
import '../models/chat_message_model.dart';

class ChatRepository {
  final SupabaseClient _supabase;

  ChatRepository({required SupabaseClient supabase}) : _supabase = supabase;

  // Create a new chat session
  Future<String> createChat(String userId) async {
    try {
      final response = await _supabase
          .from('chats')
          .insert({
            'user_id': userId,
            'title': 'New Chat',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();

      final chatId = response['id'] as String;
      return chatId;
    } catch (e) {
      rethrow;
    }
  }

  // Get all chats for a user
  Future<List<ChatModel>> getUserChats(String userId) async {
    final response = await _supabase
        .from('chats')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => ChatModel.fromJson(json)).toList();
  }

  // Get all messages for a specific chat
  Future<List<ChatMessageModel>> getChatMessages(String chatId) async {
    final response = await _supabase
        .from('messages')
        .select()
        .eq('chat_id', chatId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((json) => ChatMessageModel.fromJson(json))
        .toList();
  }

  // Save a message to a chat
  Future<void> saveMessage({
    required String chatId,
    required String role,
    required String content,
  }) async {
    try {
      await _supabase.from('messages').insert({
        'chat_id': chatId,
        'role': role,
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update chat title
  Future<void> updateChatTitle(String chatId, String title) async {
    // Use select() to get the updated rows as a List to verify update success
    final data = await _supabase
        .from('chats')
        .update({'title': title})
        .eq('id', chatId)
        .select();

    if (data.isEmpty) {
      throw Exception(
        'Failed to update chat: 0 rows affected (RLS/ID mismatch).',
      );
    }
  }

  // Delete a chat and its messages
  Future<void> deleteChat(String chatId) async {
    print('ChatRepository: Deleting chat $chatId');

    try {
      // Delete messages first (due to foreign key constraint)
      await _supabase.from('messages').delete().eq('chat_id', chatId);

      // Then delete the chat
      await _supabase.from('chats').delete().eq('id', chatId);

      print('ChatRepository: Chat deleted successfully');
    } catch (e, stackTrace) {
      print('ChatRepository.deleteChat failed!');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
