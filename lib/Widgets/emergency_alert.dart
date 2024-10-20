
import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Widgets/animate_icon.dart';

class EmergencyAlertContainer extends StatelessWidget {
  final VoidCallback? onTap;
  const EmergencyAlertContainer({
    super.key, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.RED, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.RED.withOpacity(0.2)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlinkingSvg(forLogin: false,),
            AppSpaces.width16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textHeader("Active shooter alert"),
                  AppSpaces.height8,
                  const Text(
                    "An active shooter has been reported at 143 Randall Avenue, Neasden. Law enforcement is on the scene and actively responding to the situation.",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
