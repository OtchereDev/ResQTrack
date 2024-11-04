import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

        

var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  'channel id',
  'channel name',
  icon: 'app_icon',
  importance: Importance.max,
  priority: Priority.high,
  largeIcon: DrawableResourceAndroidBitmap('app_icon'),
);
// var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    androidNotificationChannel() => const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          // 'This channel is used for important notifications.', // description
          importance: Importance.max,
        );

    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
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
      print(details.payload);
    }));

  }
  static AndroidNotificationDetails callChannel =
      const AndroidNotificationDetails('com.hackthon.resqTrack', 'call_channel',
          autoCancel: false,
          ongoing: true,
          importance: Importance.max,
          priority: Priority.max);
  static AndroidNotificationDetails normalChannel =
      const AndroidNotificationDetails(
          'com.hackthon.resqTrack', 'normal_channel',
          autoCancel: true,
          ongoing: false,
          importance: Importance.low,
          priority: Priority.low);

 static Future onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
  debugPrint
  ("-----------------On Did onDidReceiveLocalNotification -------------------------------------");
    // showDialog(
    //   context: myContext,
    //   builder: (context) => CupertinoAlertDialog(
    //     title: Text(title ?? 'No Title'), // Handle null title
    //     content: Text(body ?? 'No Body'), // Handle null body
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: const Text('OK'),
    //         onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    //       ),
    //     ],
    //   ),
    // );
  }

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  ("-----------------On Did onDidReceiveLocalNotification -------------------------------------");

  }
}
