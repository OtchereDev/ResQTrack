import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Views/Home/Emergency/ActiveEmergency/emergency_in_progress.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Views/MapViews/map_view.dart';
import 'package:resq_track/Widgets/custom_app_bar.dart';
import 'package:resq_track/Widgets/emergency_alert.dart';
import 'package:resq_track/Widgets/emergency_button.dart';
import 'package:resq_track/Widgets/recent_emergency.dart';
import 'package:resq_track/Widgets/safety_tips.dart';

class ActiveEmergencyPage extends StatelessWidget {
  const ActiveEmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpaces.height16,
                      textHeader("Active Emergency"),
                      Stack(
                        children: [
                          // The map view in the background
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const MapScreen(),
                          ),
                          
                          // Transparent GestureDetector on top of the map
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to the emergency in progress screen when the map is tapped
                                AppNavigationHelper.navigateToWidget(context, EmergencyInProgress());
                              },
                              child: Container(
                                color: Colors.transparent, // Transparent overlay
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpaces.height20,
                      const Text(
                        "Emergency alert",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      AppSpaces.height16,
                      EmergencyAlertContainer(
                        onTap: () {
                          // Handle Emergency Alert Tap
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
                      viewMoreButton("Recent emergencies", () {}),
                      AppSpaces.height8,
                      // const RecentEmergencyContainer(),
                      AppSpaces.height20,
                      viewMoreButton("Safety tips", () {}),
                      AppSpaces.height8,
                      const SafetyTipsContainer(),
                      AppSpaces.height20,
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

