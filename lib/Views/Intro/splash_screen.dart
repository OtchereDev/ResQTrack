
import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Widgets/animate_icon.dart';
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
                Spacer(),
               BlinkingSvg(forLogin: true,isBig: true,),
                Text("ResQ Track", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
             
             Spacer(),
                Text("Stay Safe, Stay Connected..."),
                AppSpaces.height20,
                
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
