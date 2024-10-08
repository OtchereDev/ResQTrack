import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/Views/Intro/init_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiProvider(
         providers: [
          // ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        builder: (context, widget) {
          return MaterialApp(
            title: 'Flutter Demo',
            navigatorObservers: [BotToastNavigatorObserver()],
            builder: BotToastInit(),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const InitScreen(),
          );
        }
      ),
    );
  }
}
