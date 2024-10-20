import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Views/Auth/Login/login.dart';
import 'package:resq_track/Views/Auth/ResetPasssword/link_sent_page.dart';
import 'package:resq_track/Widgets/animate_icon.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

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
                "Forgot your password?",
                style: GoogleFonts.annapurnaSil(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email to receive a reset link",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              AppSpaces.height20, //(height: 20),
              AppSpaces.height20, //(height: 20),

              TextFormWidget(
                emailcontroller,
                'Email',
                false,
                hint: 'someone@mail.com',
              ),
              AppSpaces.height20,
              const SizedBox(height: 20),

              CustomButton(
                title: 'Send Link',
                onTap: () {
                  AppNavigationHelper.navigateToWidget(context, LinkSentPage());
                },
              ),
              AppSpaces.height20,
              CustomOutlinedButton(
                title: 'Return To Login',
                onTap: () {
                  AppNavigationHelper.navigateToWidget(
                      context, LoginPage());
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
