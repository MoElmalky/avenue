import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../ai/ai_orchestrator/ai_orchestrator.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final AiOrchestrator aiOrchestrator;

  ChatCubit({required this.aiOrchestrator}) : super(ChatInitial());

  List<ChatMessage> _messages = [];

  void sendMessage(String text) async {
    // Optimistic UI update
    _messages = List.from(_messages)
      ..add(ChatMessage(text: text, isUser: true));
    emit(ChatLoaded(_messages));

    try {
      final (responseText, actions) = await aiOrchestrator.processUserMessage(
        text,
      );

      _messages = List.from(_messages)
        ..add(
          ChatMessage(
            text: responseText,
            isUser: false,
            suggestedActions: actions.isEmpty ? null : actions,
          ),
        );
      emit(ChatLoaded(_messages));
    } catch (e, stack) {
      print('Cubit Error: $e');
      print(stack);
      _messages = List.from(_messages)
        ..add(ChatMessage(text: "[Error] $e", isUser: false));
      emit(ChatLoaded(_messages));
    }
  }

  void confirmAllActions(int messageIndex) async {
    try {
      // 1. Optimistic UI update: Mark as executed immediately so buttons disappear
      final message = _messages[messageIndex];
      final actions = message.suggestedActions ?? [];

      if (actions.isEmpty) return;

      final updatedMessages = List<ChatMessage>.from(_messages);
      updatedMessages[messageIndex] = message.copyWith(isExecuted: true);
      _messages = updatedMessages;
      emit(ChatLoaded(List.from(_messages)));

      // 2. Perform the actual execution for all actions
      for (final action in actions) {
        await aiOrchestrator.confirmAndExecute(action);
      }

      // 3. Add success message
      final successText = actions.length == 1
          ? "Action executed successfully!"
          : "${actions.length} actions executed successfully!";

      _messages = List.from(_messages)
        ..add(ChatMessage(text: successText, isUser: false));
      emit(ChatLoaded(_messages));
    } catch (e) {
      print('Execution Error: $e');
      _messages = List.from(_messages)
        ..add(ChatMessage(text: "Error executing action: $e", isUser: false));
      emit(ChatLoaded(_messages));
    }
  }
}
