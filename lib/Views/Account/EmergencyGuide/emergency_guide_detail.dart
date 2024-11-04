import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';

class EmergencyGuideDetail extends StatelessWidget {
  EmergencyGuideDetail({super.key});

  final filerValue = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
         padding:  EdgeInsets.only(left: 20.0, top:Platform.isIOS ? 0: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackArrowButton(),
              AppSpaces.height20,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CPR",
                        style: GoogleFonts.annapurnaSil(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      AppSpaces.height20,
                      textHeader("First Aid Instructions"),
                      AppSpaces.height16,
                      Image.asset('assets/images/doc.png'),
                      AppSpaces.height20,
                      Text(
                        "Cardiopulmonary resuscitation (CPR)",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w900),
                      ),
                      AppSpaces.height8,
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris. Maecenas vitae mattis tellus. Nullam quis imperdiet augue. ",
                        style: TextStyle(fontSize: 12),
                      ),
                      AppSpaces.height8,
                      Text(
                        "Vestibulum auctor ornare leo, non suscipit magna interdum eu. Curabitur pellentesque nibh nibh, at maximus ante fermentum sit amet. Pellentesque commodo lacus at sodales sodales. Quisque sagittis orci ut diam condimentum, vel euismod erat placerat. In iaculis arcu eros, eget tempus orci facilisis id.",
                        style: TextStyle(fontSize: 12),
                      ),
                      AppSpaces.height16,
                      Image.asset('assets/images/train.png'),
                      AppSpaces.height8,
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris. Maecenas vitae mattis tellus. Nullam quis imperdiet augue. ",
                        style: TextStyle(fontSize: 12),
                      ),
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

