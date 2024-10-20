import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Views/Auth/Login/login.dart';
import 'package:resq_track/Widgets/animate_icon.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class PasswordResetSuccessful extends StatelessWidget {
  const PasswordResetSuccessful({super.key});

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
                "Password reset successful",
                style: GoogleFonts.annapurnaSil(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your password has been successfully reset",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
            
              // const Spacer(),
              CustomButton(
                title: 'Login To Account',
                onTap: () {
                  AppNavigationHelper.navigateToWidget(context, LoginPage());
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
