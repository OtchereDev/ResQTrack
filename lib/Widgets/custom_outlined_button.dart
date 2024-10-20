
import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? color;
  const CustomOutlinedButton({
    super.key, required this.title, this.onTap, this.color = AppColors.PRIMARY_COLOR,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
               height: 45,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom( side:  BorderSide(color: color!,width: 2)),
        onPressed: onTap, child: Text(title, style:  TextStyle(color: color!, fontWeight: FontWeight.w700),)));
  }
}