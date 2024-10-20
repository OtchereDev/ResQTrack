import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Views/Auth/ResetPasssword/set_password.dart';
import 'package:resq_track/Widgets/animate_icon.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class LinkSentPage extends StatelessWidget {
  LinkSentPage({super.key});

  final emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                 BlinkingSvg(forLogin: true,),
                   AppSpaces.height20,
              Text(
                "Link sent",
                style: GoogleFonts.annapurnaSil(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "A reset link has been sent to your email",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              AppSpaces.height20, //(height: 20),
              AppSpaces.height20, //(height: 20),

              CustomButton(
                title: 'Return To Login',
                onTap: () {
                  AppNavigationHelper.navigateToWidget(
                      context, SetPasswordPage());
                },
              ),
              AppSpaces.height20,
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
