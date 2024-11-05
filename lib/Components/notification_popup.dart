import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';

notificationDialog(
    {required String title, required String message, VoidCallback? onTap}) {
  BotToast.showNotification(
      backgroundColor: AppColors.WHITE,
      contentPadding: EdgeInsets.zero,
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child:CircleAvatar(backgroundColor: AppColors.RED.withOpacity(0.2),child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/icons/siren.svg'),
          ),),),
      title: (_) => textHeader(title),
      trailing: (cancelFunc) {
        return IconButton(onPressed: cancelFunc, icon: const Icon(Icons.close, size: 15,));
      },
      onTap: onTap,
      subtitle: (_) => Text(message, style: const TextStyle(fontSize: 12),),
      animationDuration: const Duration(milliseconds: 800),
      animationReverseDuration: const Duration(milliseconds: 800),
      duration: const Duration(seconds: 5),
      borderRadius: 10.0);
}
