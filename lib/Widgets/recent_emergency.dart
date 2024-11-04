
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Model/Response/emergency_response.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';

class RecentEmergencyContainer extends StatelessWidget {
  final EmergencyResponseEmergency report;
  const RecentEmergencyContainer({
    super.key, required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
            
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.WHITE,
        border: Border.all(color: const Color(0xffFCF7F8)),
        boxShadow: [
          BoxShadow(offset: const Offset(0, 4),color: Colors.black.withOpacity(0.05),blurRadius: 10)
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: const Color(0xffFFEDF1),child: SvgPicture.asset('assets/icons/police2.svg'),),
          AppSpaces.width16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  textHeader("Active shooter alert"),
                  AppSpaces.height8,
                  Text("${report.emergencies?[0].description}", maxLines: 2,  style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),),
                   AppSpaces.height16,
                   LinearProgressIndicator(value: report.emergencies?[0].severity == "HIGH"? 1.0 : report.emergencies?[0].severity == "LOW"? 0.6 : 0.4,borderRadius: BorderRadius.circular(10),minHeight: 6,color:report.emergencies?[0].severity == "HIGH"? Colors.red : report.emergencies?[0].severity == "HIGH"? Colors.green : const Color(0xffF79009),backgroundColor: const Color(0xffD0D5DD),),
                   AppSpaces.height4,
                   Text("Severity level: ${report.emergencies?[0].severity}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w300, color: AppColors.DEFAULT_TEXT),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
