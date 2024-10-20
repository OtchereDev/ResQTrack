import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/Provider/Auth/login_provider.dart';
import 'package:resq_track/Provider/Auth/verification_countdown_provider.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Provider/Report/report_provider.dart';
import 'package:resq_track/Provider/Util/util_provider.dart';
import 'package:resq_track/Services/fcm/firebase_notification_handler.dart';
import 'package:resq_track/Views/Intro/init_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp(name: "ResQTrack");

    //Handle FCM background
  // FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

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
            ChangeNotifierProvider(create: (_) => VerificationCountDownProvider()),
            ChangeNotifierProvider(create: (_) => UtilPovider()),
            ChangeNotifierProvider(create: (_) => LocationProvider()),
            ChangeNotifierProvider(create: (_) => ReportProvider()),
            ChangeNotifierProvider(create: (_) => ProfileProvider(context)),
          ],
          builder: (context, widget) {
            return MaterialApp(
              title: 'Flutter Demo',
              navigatorObservers: [BotToastNavigatorObserver()],
              debugShowCheckedModeBanner: false,
              builder: BotToastInit(),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ).copyWith(textTheme: GoogleFonts.poppinsTextTheme()),
              home: const InitScreen(),
            );
          }),
    );
  }
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data['type'] == 'call') {
    // Map<String, dynamic> bodyMap = jsonDecode(message.data['body']);
    // await CacheHelper.saveData(
    //     key: 'terminateIncomingCallData', value: jsonEncode(bodyMap));
  }
  FirebaseNotifications.showNotification(
      title: message.data['title'],
      body: message.data['body'],
      type: message.data['type']);
}
