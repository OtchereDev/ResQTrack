
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Utils/utils.dart';

class EmergencyButton extends StatelessWidget {
  final String icon, title;
  final VoidCallback? onTap;
  const EmergencyButton({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: Utils.screenWidth(context) / 3.7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.SEA_BLUE),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/$icon.svg'),
          AppSpaces.height4,
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

