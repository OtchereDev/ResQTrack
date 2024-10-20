
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';

class SafetyTipsContainer extends StatelessWidget {
  const SafetyTipsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
              
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColors.YELLOW),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.YELLOW.withOpacity(0.2)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/icons/warning.svg'),
          AppSpaces.width16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   textHeader("Clothing for cold weathers"),
                   AppSpaces.height4,
                   Text("When working in cold temperatures, pack extra clothing layers in case of emergency.", style: TextStyle(fontSize: 12),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
