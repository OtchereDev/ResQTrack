import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
class MessagingProvider extends ChangeNotifier {
  final DatabaseReference _chatRef = FirebaseDatabase.instance.ref().child('chats');
  final List<Map<String, dynamic>> _messages = [];
  StreamSubscription<DatabaseEvent>? _messageListener;

  List<Map<String, dynamic>> get messages => _messages;

  void listenToMessages({required String userA, required String userB}) {
    _messages.clear(); // Clear messages initially
    notifyListeners();

    final combinedKey = userA.hashCode <= userB.hashCode
        ? '${userA}_$userB'
        : '${userB}_$userA';

    // Detach previous listener if it exists
    _messageListener?.cancel();

    // Listen for new messages in the chat room of `combinedKey`
    _messageListener = _chatRef.child('$combinedKey/messages').onChildAdded.listen((event) {
      final message = Map<String, dynamic>.from(event.snapshot.value as Map);

      // Check if message is already in the list to avoid duplicates
      if (!_messages.any((m) => m['messageId'] == message['messageId'])) {
        _messages.add(message);
        notifyListeners();
      }
    });
  }

  // Call this method when exiting the chat screen to clear listeners
  void clearMessages() {
    _messages.clear();
    _messageListener?.cancel(); // Cancel listener
    notifyListeners();
  }

  Future<void> sendMessage(String text, String sender, String receiver) async {
    final combinedKey = sender.hashCode <= receiver.hashCode
        ? '${sender}_$receiver'
        : '${receiver}_$sender';

    final newMessageRef = _chatRef.child('$combinedKey/messages').push();
    await newMessageRef.set({
      'messageId': newMessageRef.key,
      'recipientId': receiver,
      'senderId': sender,
      'message': text,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
