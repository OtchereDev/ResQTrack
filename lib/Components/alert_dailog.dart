import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';

alertDialog(
    {required String title, required String message, bool isSuccess = false}) {
  BotToast.showNotification(
      backgroundColor: isSuccess
          ? Color(0xffF0FDF4)
          : const Color.fromARGB(255, 248, 171, 165),
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: IconButton(
            icon: !isSuccess
                ? Icon(
                    Icons.error,
                    color: Colors.red,
                  )
                : Icon(Icons.check_circle_outline,
                    color: AppColors.PRIMARY_COLOR),
            onPressed: cancel,
          )),
      title: (_) => Text(title ?? ""),
      subtitle: (_) => Text(message ?? ""),
      animationDuration: Duration(milliseconds: 800),
      animationReverseDuration: Duration(milliseconds: 800),
      duration: Duration(seconds: 3),
      borderRadius: 8.0);
}
