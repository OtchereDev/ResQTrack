import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Responder/Account/responder_profile_info.dart';
import 'package:resq_track/Views/Intro/init_screen.dart';

class ResponderAccountPage extends StatelessWidget {
  const ResponderAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<ProfileProvider>(builder: (context, profile, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 20.0, top: Platform.isIOS ? 0 : 20),
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
                              onTap: () {
                                AppNavigationHelper.navigateToWidget(
                                    context, ResponderProfile());
                              },
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
                                    SvgPicture.asset('assets/icons/bell.svg'),
                              ),
                              title: const Text(
                                "Notification Preferences",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.BLACK),
                              ),
                            ),
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
                              onTap: (){
                                profile.logout(context).then((v){
                                  AppNavigationHelper.setRootOldWidget(context, InitScreen());
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/icons/logout.svg',
                                  color: AppColors.RED,
                                ),
                              ),
                              title: const Text(
                                "Logout",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.RED),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
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
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w200, fontSize: 13),
    ),
    trailing: const Icon(Icons.keyboard_arrow_right),
  );
}
