import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Views/Home/RecentPage/recents.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class MedicalRecordPage extends StatelessWidget {
  const MedicalRecordPage({super.key});



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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: GoogleFonts.annapurnaSil(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  AppSpaces.height40,
                  textHeader("Medical Information"),
                  AppSpaces.height20,
                  textHeader("Allergies"),

                  Row(
                    children: [
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Angina",
                                           ),
                       ),
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                    ],
                  ),
                  Row(
                    children: [
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                    ],
                  ),
                  Row(
                    children: [
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                    ],
                  ),
                 
                AppSpaces.height20,
                  textHeader("Chronic Illnesses"),

                  Row(
                    children: [
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Angina",
                                           ),
                       ),
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                    ],
                  ),
                  Row(
                    children: [
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                    ],
                  ),
                  Row(
                    children: [
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                    ],
                  ),
                   AppSpaces.height20,
                  textHeader("Fatal Conditions"),

                  Row(
                    children: [
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Angina",
                                           ),
                       ),
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                    ],
                  ),
                  Row(
                    children: [
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                    ],
                  ),
                  Row(
                    children: [
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                       Expanded(
                         child: CustomCheckTile(
                                             onChanged: (val) {},
                                             name: "Medical Condition",
                                           ),
                       ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(title: 'Save', onTap: (){},),
      ),
    );
  }
}
