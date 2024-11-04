import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resq_track/Model/Request/chat_request_body.dart';
import 'package:resq_track/Services/Remote/Profile/profile_service.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatProvider extends ChangeNotifier {
  final ProfileService profile = ProfileService();
  final SpeechToText _speech = SpeechToText();

  String _reply = '';
  bool _loadPage = false;
  bool _loadReplyMessage = false;
  String _threadID = "";
  List<ChatMessage> _messages = [];

  bool get isLoading => _loadPage;
  bool get loadReplyMessage => _loadReplyMessage;
  String get threadID => _threadID;
  List<ChatMessage> get messages => _messages;

  bool _isListening = false;
  bool get isListening => _isListening;

  String _transcribedText = '';
  String get transacribedText => _transcribedText;
  Timer? _silenceTimer;

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void setLoadingPage(bool value) {
    _loadPage = value;
    notifyListeners();
  }

  void setLoadingReplyMessage(bool value) {
    _loadReplyMessage = value;
    notifyListeners();
  }

  String get reply => _reply;

  Future<void> getReply(BuildContext context, String message) async {
    addMessage(ChatMessage(
      message: message,
      userType: "user",
      time: DateTime.now().toIso8601String(),
    ));
    setLoadingReplyMessage(true);

    try {
      final response = await profile
          .replyChat(context, {"content": message, "chatId": _threadID});
      setLoadingReplyMessage(false);
      print(response);

      if (response['status'] == true) {
        addMessage(ChatMessage(
          message: response['data']['data']["response"],
          userType: "system",
          time: DateTime.now().toIso8601String(),
        ));
        notifyListeners();
      } else {
        print("Error: ${response['message']}");
      }
    } catch (error) {
      setLoadingReplyMessage(false);
      print("An error occurred: $error");
      // Optionally show an error message to the user
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }

  Future<bool> initChat(BuildContext context) async {
    _messages.clear();
    setLoadingPage(true);
    bool isSuccess = false;

    try {
      final response = await profile.initChat(context);
      print("Chat Initialization Response: $response");

      if (response['status'] == true) {
        _threadID = response['data']['chat']['_id'];
        isSuccess = true;
      } else {
        print("Failed to initialize chat: ${response['message']}");
      }
    } catch (error) {
      print("An error occurred during chat initialization: $error");
    } finally {
      setLoadingPage(false);
      notifyListeners(); // Ensure the UI updates even if initialization fails
    }

    return isSuccess;
  }

  Future<void> startListening() async {
    await _speech.initialize();
    _isListening = true;
    // _transcribedText = ''; // Clear previous text
    notifyListeners();
    _speech.listen(onResult: (result) {
       _isListening = false;
      print("------${result.confidence}--${result.recognizedWords}----------");
      _transcribedText = result.recognizedWords; // Update transcribed text
      // _resetSilenceTimer();
         notifyListeners();
    });
    notifyListeners();
  }

  void stopListening() {
    _speech.stop();
    _isListening = false;
    _silenceTimer?.cancel(); // Cancel any existing timer
    notifyListeners();
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel(); // Cancel previous timer
    _silenceTimer = Timer(Duration(seconds: 3), () {
      stopListening(); // Stop listening after timeout
    });
    notifyListeners();
  }

  @override
  void dispose() {
    stopListening(); // Ensure listening is stopped on dispose
    super.dispose();
  }
}
