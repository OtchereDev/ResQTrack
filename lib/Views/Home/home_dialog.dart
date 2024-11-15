import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Chat/chat_provider.dart';
import 'package:resq_track/Provider/Report/report_provider.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Views/Home/Emergency/emergency_alert_message.dart';
import 'package:resq_track/Widgets/emergency_alert.dart';
import 'package:resq_track/Widgets/emergency_button.dart';
import 'package:resq_track/Widgets/recent_emergency.dart';
import 'package:resq_track/Widgets/safety_tips.dart';



class HomeDialog extends StatefulWidget {
  const HomeDialog({super.key});

  @override
  State<HomeDialog> createState() => _HomeDialogState();
}

class _HomeDialogState extends State<HomeDialog> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).getEmergencyReport(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  var  text2Speech = context.watch<ChatProvider>();
    return Consumer<ReportProvider>(
      builder: (context, report, _) {
        return Container(
          height: Utils.screenHeight(context) * 0.5,
          padding: const EdgeInsets.only(left: 25,right: 25, top: 20),
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), 
              topRight: Radius.circular(30),
            ),
            color: AppColors.WHITE,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Emergency alert",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                AppSpaces.height16,
                EmergencyAlertContainer(
                  onTap: () {
                    AppNavigationHelper.navigateToWidget(context, EmergencyAlertMessage());
                  },
                ),
                AppSpaces.height20,
                const Text(
                  "Emergency services",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                AppSpaces.height8,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EmergencyButton(
                      icon: 'police2',
                      title: "Police",
                    ),
                    EmergencyButton(
                      icon: 'fire2',
                      title: "Fire Rescue",
                    ),
                    EmergencyButton(
                      icon: 'ambulance2',
                      title: "Ambulance",
                    ),
                  ],
                ),
                AppSpaces.height20,
                viewMoreButton("Recent emergencies ${text2Speech.isListening}", () {
                  // AppNavigationHelper.navigateToWidget(context, AgoraMyApp());
                }),
                AppSpaces.height8,
                ...List.generate(
                  report.emergencyRes.emergencies?.take(1).length ?? 0,
                  (index) {
                    return RecentEmergencyContainer(report: report.emergencyRes.emergencies![index]);
                  },
                ),
                AppSpaces.height20,
                viewMoreButton("Safety tips", () {
                  // AppNavigationHelper.navigateToWidget(context, TextToSpeech());
                }),
                AppSpaces.height8,
                const SafetyTipsContainer(),
                AppSpaces.height20,
              ],
            ),
          ),
        );
      },
    );
  }
}

textHeader(String title) {
  return Text(
    title,
    style: const TextStyle(
        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.BLACK),
  );
}

viewMoreButton(String title, VoidCallback onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      TextButton(
          onPressed: onTap,
          child: const Text(
            "view all",
            style: TextStyle(
                decoration: TextDecoration.underline, color: AppColors.BLACK),
          ))
    ],
  );
}
