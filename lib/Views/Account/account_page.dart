import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Views/Account/EmergencyGuide/first_aid_instruction.dart';
import 'package:resq_track/Views/Account/Feedback/feedback_page.dart';
import 'package:resq_track/Views/Account/Profile/emergency_contact.dart';
import 'package:resq_track/Views/Account/Profile/medical_record.dart';
import 'package:resq_track/Views/Account/Profile/personal_info.dart';
import 'package:resq_track/Views/Chat/chat_gpt.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, profile, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
               padding:  EdgeInsets.only(left: 20.0, top:Platform.isIOS ? 0: 20),
                  child: Text(
                    "Account",
                    style: GoogleFonts.annapurnaSil(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.BLACK),
                  ),
                ),
                AppSpaces.height20,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 2, color: AppColors.YELLOW)),
                                  child: const CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                        "https://avatar.iran.liara.run/public"),
                                  )),
                              AppSpaces.height16,
                               Text(
                                profile.getUserFullname(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        AppSpaces.height20,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xffD0D5DD).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: SvgPicture.asset(
                                      'assets/icons/user_circle.svg'),
                                ),
                                title: const Text(
                                  "Profile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.BLACK),
                                ),
                              ),
                              accountTile(title: 'Personal Info', onTap: () {
                                AppNavigationHelper.navigateToWidget(context, PersonalInfoPage());
                              }),
                              accountTile(
                                  title: 'Emergency Contact', onTap: () {
                                    AppNavigationHelper.navigateToWidget(context, EmergencyContactPage());
                                  }),
                              accountTile(
                                  title: 'Medical Information', onTap: () {
                                    AppNavigationHelper.navigateToWidget(context, MedicalRecordPage());
                                  }),
                            ],
                          ),
                        ),
                        AppSpaces.height20,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xffD0D5DD).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child:
                                      SvgPicture.asset('assets/icons/note.svg'),
                                ),
                                title: const Text(
                                  "Emergency Guides",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.BLACK),
                                ),
                              ),
                              accountTile(
                                  title: 'First Aid Instructions', onTap: () {
                                    AppNavigationHelper.navigateToWidget(context, FirstAidinstructionPage());
                                  }),
                              accountTile(
                                  title: 'First Aid Tips',
                                  onTap: () {
                                    AppNavigationHelper.navigateToWidget(context, ChatPage());
            
                                  }),
                              accountTile(
                                  title: 'Emergency Procedures', onTap: () {
                                    AppNavigationHelper.navigateToWidget(context, FirstAidinstructionPage());
            
                                  }),
                            ],
                          ),
                        ),
                         AppSpaces.height20,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xffD0D5DD).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child:
                                      SvgPicture.asset('assets/icons/chat.svg'),
                                ),
                                title: const Text(
                                  "Feedback",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.BLACK),
                                ),
                              ),
                              accountTile(
                                  title: 'Send Feedback', onTap: () {
                                    AppNavigationHelper.navigateToWidget(context, FeedbackPage());
                                  }),
                        
                                  AppSpaces.height20,
                             
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}

accountTile({required String title, VoidCallback? onTap}) {
  return ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    leading: const CircleAvatar(
      backgroundColor: Colors.transparent,
    ),
    title: Text(title, style: TextStyle(fontWeight: FontWeight.w200, fontSize: 13),),
    trailing: const Icon(Icons.keyboard_arrow_right),
  );
}
