
import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset(logo, width: 100, ),
                // AppSpaces.height8,
                const Text("...in good hands", style: TextStyle(color: AppColors.SECONDARY_COLOR, fontSize: 16, fontWeight: FontWeight.w600),)
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
