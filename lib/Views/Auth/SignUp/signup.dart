import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/phoneNumberText.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Model/Request/user_request.dart';
import 'package:resq_track/Utils/formatters.dart';
import 'package:resq_track/Views/Auth/SignUp/signup_password.dart';
import 'package:resq_track/Widgets/animate_icon.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';

class SignUpPersonalDetails extends StatelessWidget {
  SignUpPersonalDetails({super.key});
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   BlinkingSvg(forLogin: true,),
                   AppSpaces.height20,
                Text(
                  "Create Account",
                  style: GoogleFonts.annapurnaSil(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "1/3 - Provide your personal details",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                AppSpaces.height20, //(height: 20),
                TextFormWidget(
                  nameController,
                  'Name',
                  false,
                  hint: 'John Doe',
                  validate: true,
                  validateMsg: 'Name is required',
                ),
                AppSpaces.height20,
                Text(
                  "Phone Number",
                  style: const TextStyle(
                      color: AppColors.DEFAULT_TEXT, fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                PhoneNumberTextField(
                  controller: phoneController,
                  hintText: '+1 234 356 980',
                  validate: true,
                ),
                // TextFormWidget(
                //   phoneController,
                //   'Phone Number',
                //   false,
                //   hint: '+1 234 356 980',
                //   validate: true,
                //   validateMsg: 'Phone number is required',
                // ),
                AppSpaces.height20,
                TextFormWidget(
                  emailController,
                  'Email',
                  false,
                  hint: 'someone@mail.com',
                  validateEmail: true,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 50,
                            child: CustomOutlinedButton(
                              title: 'Back',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ))),
                    AppSpaces.width16,
                    Expanded(
                        child: CustomButton(
                      title: 'Next',
                      onTap: () {
                        if (formKey.currentState?.validate() == true) {
                          UserRequest userRequest = UserRequest();

                          userRequest.email = emailController.text.trim();
                          userRequest.name = nameController.text;
                          userRequest.phoneNumber =   "+${Formatters.formatToInternationNumber(countryCode,  phoneController.text.trim())}";

                          AppNavigationHelper.navigateToWidget(
                              context,
                              CreatePasswordPage(
                                userRequest: userRequest,
                              ));
                        }
                      },
                    )),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
