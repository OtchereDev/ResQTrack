import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Provider/Chat/user_messaging_provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';

class UserChatScreen extends StatefulWidget {
  final String recipientId, senderId;

  const UserChatScreen(
      {super.key, required this.recipientId, required this.senderId});

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final chatProvider =
          Provider.of<MessagingProvider>(context, listen: false);
      chatProvider.listenToMessages(
          userA: widget.recipientId, userB: widget.senderId);
    });
  }

  @override
  void dispose() {
    final chatProvider = Provider.of<MessagingProvider>(context, listen: false);
    chatProvider.clearMessages(); // Clear messages and detach listeners
    super.dispose();
  }

  Future<void> _sendMessage(BuildContext context) async {
    final authProvider = Provider.of<ProfileProvider>(context, listen: false);
    final chatProvider = Provider.of<MessagingProvider>(context, listen: false);

    if (_controller.text.trim().isEmpty ||
        authProvider.currentUserProfile?.id == null) return;

    try {
      await chatProvider.sendMessage(
        _controller.text.trim(),
        authProvider.currentUserProfile?.id ?? "",
        widget.recipientId,
      );
      _controller.clear();
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Consumer<ProfileProvider>(builder: (context, profile, _) {
        var user = profile.currentUserProfile;
        return Column(
          children: [
            Expanded(
              child: Consumer<MessagingProvider>(
                builder: (context, chatProvider, _) {
                  return ListView.builder(
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return BubbleSpecialThree(
                        text: message['message'],
                        color: message['senderId'] == user?.id
                            ? AppColors.PRIMARY_COLOR
                            : AppColors.GREEN,
                        tail: true,
                        isSender: message['senderId'] == user?.id,
                        textStyle: TextStyle(
                            color: message['senderId'] == user?.id
                                ? Colors.white
                                : Colors.white,
                            fontSize: 15),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormWidget(
                _controller,
                "",
                false,
                hint: "Type your question",
                onIconTap: () => _sendMessage(context),
                icon: FeatherIcons.send,
              ),
            ),
            AppSpaces.height8,
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           controller: _controller,
            //           decoration: const InputDecoration(hintText: 'Enter message...'),
            //         ),
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.send),
            //         onPressed: () => _sendMessage(context),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        );
      }),
    );
  }
}
