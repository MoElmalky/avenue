import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/di/injection_container.dart';
import '../logic/chat_cubit.dart';
import '../logic/chat_state.dart';
import '../logic/chat_session_cubit.dart';
import '../logic/chat_session_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart' as auth_state;

class AiChatView extends StatelessWidget {
  const AiChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, auth_state.AuthState>(
      builder: (context, authState) {
        if (authState is! auth_state.Authenticated) {
          return const Scaffold(body: Center(child: Text('Please log in')));
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ChatSessionCubit(repository: sl(), userId: authState.userId)
                    ..initialize(),
            ),
            BlocProvider(
              create: (context) => ChatCubit(
                aiOrchestrator: sl(),
                sessionCubit: context.read<ChatSessionCubit>(),
              ),
            ),
          ],
          child: const _ChatScreen(),
        );
      },
    );
  }
}

class _ChatScreen extends StatefulWidget {
  const _ChatScreen();

  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  String? _lastChatId;
  bool _isSwitching = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatSessionCubit, ChatSessionState>(
      listener: (context, sessionState) {
        if (sessionState is ChatSessionLoaded) {
          // If the chatId changed, we are transitioning to a different chat
          if (sessionState.currentChatId != _lastChatId) {
            final oldId = _lastChatId;
            _lastChatId = sessionState.currentChatId;

            // CRITICAL FIX: Only load messages if we are explicitly switching.
            // If oldId was empty and newId is not, it means we just created a chat
            // for the first message. In this case, ChatCubit ALREADY has the messages.
            // Overwriting them now will cause the 'User message disappears' bug
            // because Supabase might not have indexed it fast enough or the
            // messages list in sessionState is lagging.
            if (oldId != null &&
                oldId.isEmpty &&
                sessionState.currentChatId.isNotEmpty &&
                !_isSwitching) {
              return;
            }

            // Normal switching (e.g. from Drawer) or loading first chat
            context.read<ChatCubit>().loadMessages(sessionState.messages);
            _isSwitching = false; // Reset flag
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Assistant'),
          backgroundColor: const Color(0xFF004D61),
          foregroundColor: Colors.white,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  context.read<ChatSessionCubit>().loadChats();
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        endDrawer: _ChatDrawer(
          onSwitch: () {
            _isSwitching = true;
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  List<ChatMessage> messages = [];
                  if (state is ChatLoaded) {
                    messages = state.messages;
                  }

                  if (messages.isEmpty && state is! ChatError) {
                    return const Center(
                      child: Text(
                        'Hi! I can help you manage your tasks.\nTry "Add a meeting tomorrow at 10am"',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return Align(
                        alignment: msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? const Color(0xFF004D61)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              msg.isUser
                                  ? Text(
                                      msg.text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  : MarkdownBody(
                                      data: msg.text,
                                      styleSheet: MarkdownStyleSheet(
                                        p: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                              if (msg.suggestedActions != null &&
                                  !msg.isExecuted)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: ElevatedButton(
                                    onPressed: () => context
                                        .read<ChatCubit>()
                                        .confirmAllActions(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF004D61),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Text(
                                      msg.suggestedActions!.length == 1
                                          ? 'Confirm'
                                          : 'Confirm ${msg.suggestedActions!.length} Actions',
                                    ),
                                  ),
                                ),
                              if (msg.isExecuted)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Executed',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const _ChatInput(),
          ],
        ),
      ),
    );
  }
}

// TODO: This drawer will be connected to Supabase chat tables later
class _ChatDrawer extends StatelessWidget {
  final VoidCallback onSwitch;
  const _ChatDrawer({required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<ChatSessionCubit, ChatSessionState>(
        builder: (context, state) {
          final chatList = state is ChatSessionLoaded ? state.chatList : [];
          final currentChatId = state is ChatSessionLoaded
              ? state.currentChatId
              : null;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF004D61)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'AI Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Your personal task manager',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('New Chat'),
                onTap: () {
                  onSwitch();
                  context.read<ChatSessionCubit>().createNewChat();
                  context.read<ChatCubit>().reset();
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ...chatList.map((chat) {
                final isActive = chat.id == currentChatId;
                return ListTile(
                  leading: Icon(
                    Icons.chat,
                    color: isActive ? const Color(0xFF004D61) : null,
                  ),
                  title: Text(
                    chat.title,
                    style: TextStyle(
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isActive ? const Color(0xFF004D61) : null,
                    ),
                  ),
                  subtitle: Text(_formatDate(chat.createdAt)),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'rename') {
                        _showRenameDialog(context, chat.id, chat.title);
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, chat.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Rename'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  selected: isActive,
                  onTap: () {
                    if (!isActive) {
                      onSwitch();
                      context.read<ChatSessionCubit>().switchToChat(chat.id);
                    }
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    String chatId,
    String currentTitle,
  ) {
    final controller = TextEditingController(text: currentTitle);
    final sessionCubit = context.read<ChatSessionCubit>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: sessionCubit,
        child: Builder(
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Rename Chat'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Enter new title'),
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final newTitle = controller.text.trim();
                    if (newTitle.isNotEmpty) {
                      sessionCubit.renameChat(chatId, newTitle);
                    }
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String chatId) {
    final sessionCubit = context.read<ChatSessionCubit>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: sessionCubit,
        child: Builder(
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Delete Chat'),
              content: const Text(
                'Are you sure you want to delete this chat? This action cannot be undone.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    sessionCubit.deleteChat(chatId);
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _ChatInput extends StatefulWidget {
  const _ChatInput();

  @override
  State<_ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<_ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF004D61)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().sendMessage(text);
    _controller.clear();
    _focusNode.requestFocus();
  }
}
