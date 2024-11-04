import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Services/fcm/notification_service.dart';
import '../Local/shared_prefs_manager.dart';

class PushNotificationService {
  Random random = Random();
  final _sharedPrefsManager = SharedPrefManager();

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage(context) async {
    await Firebase.initializeApp();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      print("============On App Open ==========Remote=============${remoteMessage.data}");
       debugPrint('Receive open app: $remoteMessage ');
      debugPrint(
          'InOpenAppNotifyBody ${remoteMessage.data['body'].toString()}');
      if (Platform.isIOS) {
        showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(remoteMessage.notification!.title ?? ''),
                  content: Text(remoteMessage.notification!.body ?? ''),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(),
                    )
                  ],
                ));
      }
    });
    generateToken();
    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initSetttings = InitializationSettings(
        android: androidSettings, iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initSetttings,
        onDidReceiveNotificationResponse: ((details) {
      // print(details.payload);
    }));
// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      RemoteNotification? notification = remoteMessage?.notification;
      AndroidNotification? android = remoteMessage?.notification?.android;
      print("--------$remoteMessage---------");
      
// If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      print("-----${android?.toMap()}.---${remoteMessage?.data}---------${notification?.body}");
      //Foreground Msg
      // if (remoteMessage!.data['type'] != 'call') {
      //   showNotification(
      //       title: remoteMessage.data['title'],
      //       body: remoteMessage.data['body'],
      //       type: remoteMessage.data['type']);
      // }
    });

  }

  enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        // 'This channel is used for important notifications.', // description
        importance: Importance.max,
      );


  Future<String?> generateToken() async {
    // Request notification permissions from the user
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();

    // Check if permission is granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Try to get the APNS token for iOS (if on iOS)
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

      // Wait for the APNS token to be available, if on iOS
      if (apnsToken == null && Platform.isIOS) {
        apnsToken = await _waitForAPNSToken();
      }

      // Get the FCM token for the device (both Android and iOS)
      String? token = await FirebaseMessaging.instance.getToken();

      print("Token--->$token");

      // Store the token if available
      if (token != null || apnsToken != null) {
        await _sharedPrefsManager
            .setPushNotificationToken(token ?? apnsToken ?? "");
      }

      return token;
    } else {
      // Permission not granted, handle accordingly
      print('User declined or has not accepted notification permissions');
      return null;
    }
  }

// Helper function to wait for the APNS token on iOS
  Future<String?> _waitForAPNSToken(
      {int maxRetries = 5, Duration delay = const Duration(seconds: 2)}) async {
    int retries = 0;
    String? apnsToken;

    while (retries < maxRetries) {
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        break;
      }
      retries++;
      await Future.delayed(delay);
    }

    if (apnsToken == null) {
      print('APNS token not available after $maxRetries retries.');
    }

    return apnsToken;
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // print("=======Close =========Notification =>${body}");
  }

  Future<void> cancelNotifications(int id) async {
    // NOTIFICATION_ID should be integer
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }



  static void showNotification(
      {required String title,
      required String body,
      required String type}) async {
    debugPrint('callDataFromNotify $body');
    if (type == 'call') {
      Map<String, dynamic> bodyJson = jsonDecode(body);

      int notificationId = Random().nextInt(1000);
      var ios = const DarwinNotificationDetails();
      var platform = NotificationDetails(android: NotificationService.callChannel, iOS: ios);
      await flutterLocalNotificationsPlugin.show(
          notificationId,
          '📞Ringing...',
          '${CallModel.fromJson(bodyJson).callerName} is calling you',
          platform,
          payload: body);
      await Future.delayed(const Duration(seconds: callDurationInSec), () {
        flutterLocalNotificationsPlugin
            .cancel(notificationId)
            .then((value) {
          showMissedCallNotification(
              senderName: bodyJson['sender']['full_name']);
        });
      });
    } else {
      int notificationId = Random().nextInt(1000);
      var ios = const DarwinNotificationDetails();
      var platform = NotificationDetails(android: NotificationService.normalChannel, iOS: ios);
      await flutterLocalNotificationsPlugin
          .show(notificationId, title, body, platform, payload: body);
    }
  }

  static void showMissedCallNotification({required String senderName}) async {
    int notificationId = Random().nextInt(1000);
    var ios = const DarwinNotificationDetails();
    var platform = NotificationDetails(android: NotificationService.normalChannel, iOS: ios);
    await flutterLocalNotificationsPlugin.show(
        notificationId,
        '📞Missed Call',
        'You have missed call from $senderName',
        platform,
        payload: 'missedCall');
  }}

