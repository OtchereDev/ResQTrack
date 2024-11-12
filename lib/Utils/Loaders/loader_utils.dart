
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Utils/utils.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: Utils.screenHeight(context) - 240,
      width: Utils.screenWidth(context),
      color: AppColors.WHITE,
      child: Center(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CupertinoActivityIndicator() //LottieBuilder.asset('assets/images/loader.json'),
      )),
    );
  }
}
