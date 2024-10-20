import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackArrowButton(),
              AppSpaces.height20,
              Text(
                "Privacy and Data Sharing",
                style: GoogleFonts.annapurnaSil(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
              AppSpaces.height16,
              const Text(
                "Location Information",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.DEFAULT_TEXT),
              ),
              AppSpaces.height20,
              ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: const Text("Live location is always on, even when an \nemergency is not being reported.", style: TextStyle(fontSize: 12),),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Live location"),
                      SizedBox(
                        width: 40,
                        height: 30,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: true,
                            onChanged: (bool value1) {},
                            activeColor: AppColors.WHITE,
                            activeTrackColor: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    ],
                  )),
                  AppSpaces.height20,
                  const Divider(),
                  AppSpaces.height20,
                   ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: const Text("Share location with first responders in \nan emergency", style: TextStyle(fontSize: 12),),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Share my location"),
                      SizedBox(
                        width: 40,
                        height: 30,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: true,
                            onChanged: (bool value1) {},
                            activeColor: AppColors.WHITE,
                            activeTrackColor: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
