import 'dart:io';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Provider/Chat/chat_provider.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/custom_app_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initChat(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: Consumer<ChatProvider>(builder: (context, chatProviders, _) {
        return SafeArea(
          child: chatProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const BackArrowButton(),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                top: Platform.isIOS ? 0 : 20,
                                right: 20),
                            child: Text(
                              "Assistant",
                              style: GoogleFonts.annapurnaSil(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.BLACK),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                      AppSpaces.height20,
                      Expanded(
                        child: ListView.builder(
                          itemCount: chatProvider.messages.length,
                          itemBuilder: (context, index) {
                            var chatData = chatProvider.messages[index];
                            return BubbleSpecialThree(
                              text:  chatData.message,
                              color: chatData.userType == "user"
                                  ? AppColors.PRIMARY_COLOR
                                  :  AppColors.GREEN,
                              tail: true,
                              isSender: chatData.userType == "user",
                              textStyle: TextStyle(
                                color: chatData.userType == "user" ? Colors.white : Colors.white,
                                fontSize: 15
                              ),
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
                          onIconTap: chatProvider.loadReplyMessage
                              ? null
                              : () async {
                                  await chatProvider.getReply(context, _controller.text);
                                  _controller.clear();
                                },
                          icon: chatProvider.loadReplyMessage
                              ? FeatherIcons.loader
                              : FeatherIcons.send,
                        ),
                      ),
                      AppSpaces.height8,
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
