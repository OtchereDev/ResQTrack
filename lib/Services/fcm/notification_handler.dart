import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();
  static late BuildContext myContext;

  // Change the type of selectNotificationCallback
  static void initNotification({
    required BuildContext context,
    required DidReceiveBackgroundNotificationResponseCallback? selectNotificationCallback,
  }) {
    myContext = context;
    
    var initAndroid = const AndroidInitializationSettings('@drawable/ic_notify');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    var initSettings = InitializationSettings(android: initAndroid, iOS: initializationSettingsIOS);
    
    // Pass the correct type for the callback
    flutterLocalNotificationPlugin.initialize(initSettings, 
      onDidReceiveBackgroundNotificationResponse: selectNotificationCallback
    );
  }

  static Future onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
    showDialog(
      context: myContext,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title ?? 'No Title'), // Handle null title
        content: Text(body ?? 'No Body'), // Handle null body
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('OK'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
    );
  }
}