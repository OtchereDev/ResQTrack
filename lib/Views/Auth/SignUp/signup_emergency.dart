import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/alert_dailog.dart';
import 'package:resq_track/Components/phoneNumberText.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Model/Request/user_request.dart';
import 'package:resq_track/Provider/Auth/login_provider.dart';
import 'package:resq_track/Utils/formatters.dart';
import 'package:resq_track/Widgets/animate_icon.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';

class SignUpEmergency extends StatelessWidget {
  final UserRequest userRequest;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  SignUpEmergency({super.key, required this.userRequest});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<AuthProvider>(builder: (context, auth, _) {
          return auth.loadPage
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlinkingSvg(
                          forLogin: true,
                        ),
                        AppSpaces.height20,
                        Text(
                          "Create Account",
                          style: GoogleFonts.annapurnaSil(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "3/3 - Provide your personal details",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                        AppSpaces.height20,
                        TextFormWidget(
                          nameController,
                          'Emergency Contact Name',
                          false,
                          hint: 'John Doe',
                          validate: true,
                          validateMsg: 'Name is required',
                        ),
                        AppSpaces.height20,
                        const Text(
                          "Emergency Contact Phone Number",
                          style: TextStyle(
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
                        //   'Emergency Contact Phone Number',
                        //   false,
                        //   hint: '+1 234 356 980',
                        //   validate: true,
                        //   validateMsg: 'Phone number required',
                        // ),
                        AppSpaces.height20,
                        TextFormWidget(
                          emailController,
                          'Emergency Contact Email',
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
                                ),
                              ),
                            ),
                            AppSpaces.width16,
                            Expanded(
                              child: CustomButton(
                                title: 'Done',
                                onTap: () {
                                  if (formKey.currentState?.validate() ==
                                      true) {
                                    // Ensure emergencyContact is not null
                                    userRequest.emergencyContact ??=
                                        EmergencyContact();

                                    userRequest.emergencyContact!.email =
                                        emailController.text.trim();
                                    userRequest.emergencyContact!.phoneNumber =
                                        "+${Formatters.formatToInternationNumber(countryCode, phoneController.text.trim())}";
                                    userRequest.emergencyContact!.name =
                                        nameController.text.trim();

                                    // Print or perform any further action
                                    print({
                                      'userRequest': userRequest.toJson(),
                                    });
                                    auth
                                        .signUp(context, userRequest)
                                        .then((val) {
                                      if (val == true) {
                                        alertDialog(
                                            title: 'Register successful',
                                            message: "Done",
                                            isSuccess: true);
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
