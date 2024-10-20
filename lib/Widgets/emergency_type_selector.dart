
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resq_track/AppTheme/app_config.dart';

class EmergencyTypeSelect extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onTap;
  final String title, icon;
  const EmergencyTypeSelect({
    super.key, required this.isActive, this.onTap, required this.title, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color:isActive ?  AppColors.PRIMARY_COLOR: AppColors.SEA_BLUE),
          color: AppColors.SEA_BLUE
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/$icon.svg'),
            AppSpaces.width8,
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: AppColors.PRIMARY_COLOR),)
          ],
        ),
      ),
    );
  }
}