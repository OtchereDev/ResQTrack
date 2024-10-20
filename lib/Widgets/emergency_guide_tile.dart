

import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Views/Notification/notification_page.dart';

class EmergencyGuideTile extends StatelessWidget {
  final VoidCallback? onTap;
  const EmergencyGuideTile({
    super.key, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Color(0xffD0D5DD).withOpacity(0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/doc.png'),
              AppSpaces.height16,
              Text(
                "Cardiopulmonary resuscitation (CPR)",
                style: TextStyle(
                    color: AppColors.DEFAULT_TEXT,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
              AppSpaces.height16,
              Text(
                  "Donec dictum convallis odio. Donec eu nunc eu est faucibus elementum. Mauris in risus aliq...."),
                  AppSpaces.height8,
                  CustomChip(isActive: false, title: 'Learn More', onTap: (){},)
            ],
          ),
        ),
      ),
    );
  }
}
