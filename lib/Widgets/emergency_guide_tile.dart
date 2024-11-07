

import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/image_viewer.dart';
import 'package:resq_track/Model/Response/guide_response_mode.dart';
import 'package:resq_track/Views/Notification/notification_page.dart';

class EmergencyGuideTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Guide? guide;
  const EmergencyGuideTile({
    super.key, this.onTap, required this.guide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: const Color(0xffD0D5DD).withOpacity(0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageViewer(url: guide?.image??"", height: 200,),
              // Image.network("https://images.pexels.com/photos/28271058/pexels-photo-28271058/free-photo-of-cpr-first-aid-cardiopulmonary-resuscitation-adult-pierwsza-pomoc-ratowanie-zycia.jpeg"),
              AppSpaces.height16,
              Text(
                "${guide?.title}",
                style: const TextStyle(
                    color: AppColors.DEFAULT_TEXT,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
              AppSpaces.height16,
              Text(
                  guide?.content??""),
                  AppSpaces.height8,
                  CustomChip(isActive: false, title: 'Learn More', onTap: (){},)
            ],
          ),
        ),
      ),
    );
  }
}
