import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/Provider/Auth/login_provider.dart';
import 'package:resq_track/Provider/Auth/verification_countdown_provider.dart';
import 'package:resq_track/Provider/Call/call_provider.dart';
import 'package:resq_track/Provider/Chat/chat_provider.dart';
import 'package:resq_track/Provider/Chat/user_messaging_provider.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Map/map_provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Provider/Report/report_provider.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Provider/Setup/setup_provider.dart';
import 'package:resq_track/Provider/Util/util_provider.dart';
import 'package:resq_track/Responder/Emergency/test_modal_call.dart';
import 'package:resq_track/Responder/Learn/learn_page.dart';
import 'package:resq_track/Services/Firbase/request_api.dart';
import 'package:resq_track/Services/fcm/notification.dart';
import 'package:resq_track/Services/fcm/notification_service.dart';
import 'package:resq_track/Views/Intro/init_screen.dart';
import 'package:resq_track/firebase_options.dart';

 var naviKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "ResQTrack",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Handle FCM background
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

  //
  NotificationService().init();


  // PushNotificationService().setupInteractedMessage();
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(
                create: (_) => VerificationCountDownProvider()),
            ChangeNotifierProvider(create: (_) => UtilPovider()),
            ChangeNotifierProvider(create: (_) => LocationProvider()),
            ChangeNotifierProvider(create: (_) => ReportProvider()),
            ChangeNotifierProvider(
                create: (_) => MapProvider()..initializeMap(context)),
            ChangeNotifierProvider(create: (_) => CallProvider()),
            ChangeNotifierProvider(create: (_) => MessagingProvider()),
            ChangeNotifierProvider(create: (_) => ChatProvider()),
        Provider<RequestApi>(create: (_) => RequestApi()),
            ChangeNotifierProvider(create: (_) => ResponderProvider()),
            ChangeNotifierProvider(create: (_) => ProfileProvider(context)),
            ChangeNotifierProvider(create: (_) {
              return SetupProvider()
                ..listenToInComingCalls("")
                ..getUsersRealTime()
                ..getCallHistoryRealTime()
                ..updateFcmToken();
                
            }),
          ],
          builder: (context, widget) {
            PushNotificationService().setupInteractedMessage(context);
            return GetMaterialApp(
              title: 'Flutter Demo',
              navigatorKey: naviKey,
              navigatorObservers: [BotToastNavigatorObserver()],
              debugShowCheckedModeBanner: false,
              builder: BotToastInit(),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ).copyWith(textTheme: GoogleFonts.poppinsTextTheme()),
              home:  const InitScreen(),
            );
          }),
    );
  }
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  if (message.data['type'] == 'call') {
    Map<String, dynamic> bodyMap = jsonDecode(message.data['body']);
    debugPrint("---------BK----------$bodyMap-----------------");
    // await CacheHelper.saveData(
    //     key: 'terminateIncomingCallData', value: jsonEncode(bodyMap));
  }
  PushNotificationService.showNotification(
      title: message.data['title'],
      body: message.data['body'],
      type: message.data['type']);
}
