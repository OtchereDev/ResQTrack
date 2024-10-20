import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/passwordField.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Utils/Dialogs/notifications.dart';
import 'package:resq_track/Views/Auth/ResetPasssword/password_reset_successful.dart';
import 'package:resq_track/Widgets/animate_icon.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/password_check.dart';

class SetPasswordPage extends StatefulWidget {
  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  String password = '';
  bool has8Characters = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialCharacter = false;

  final showControls = ValueNotifier(false);

  void checkPassword(String value) {
    setState(() {
      password = value;
      has8Characters = password.length >= 8;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSpecialCharacter =
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  final passwordTextController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  double getPasswordStrength() {
    int strength = 0;
    if (has8Characters) strength++;
    if (hasUppercase) strength++;
    if (hasLowercase) strength++;
    if (hasNumber) strength++;
    if (hasSpecialCharacter) strength++;

    return strength / 5;
  }

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
              BlinkingSvg(
                forLogin: true,
              ),
              AppSpaces.height20,
              Text(
                "Create new password",
                style: GoogleFonts.annapurnaSil(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Create a new password for your account",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                  valueListenable: showControls,
                  builder: (context, show, _) {
                    return PasswordField(
                      inputType: TextInputType.text,
                      validateMsg: '',
                      controller: passwordTextController,
                      title: "Password",
                      hintText: 'Password',
                      onValueChange: (val) {
                        checkPassword(val);
                        if (val.isNotEmpty) {
                          showControls.value = true;
                        } else {
                          showControls.value = false;
                        }
                      },
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: showControls,
                  builder: (context, show, _) {
                    return !show
                        ? SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text("Strength: "),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: getPasswordStrength(),
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        getPasswordStrength() < 0.4
                                            ? Colors.red
                                            : getPasswordStrength() < 0.7
                                                ? Colors.yellow
                                                : Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Your password must include:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: PasswordCriteriaRow(
                                      criteriaMet: has8Characters,
                                      text: "At least 8 characters",
                                    ),
                                  ),
                                  Expanded(
                                      child: PasswordCriteriaRow(
                                    criteriaMet: hasLowercase,
                                    text: "Lowercase letters",
                                  ))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: PasswordCriteriaRow(
                                      criteriaMet: hasUppercase,
                                      text: "Uppercase letters",
                                    ),
                                  ),
                                  Expanded(
                                    child: PasswordCriteriaRow(
                                      criteriaMet: hasNumber,
                                      text: "Numbers",
                                    ),
                                  )
                                ],
                              ),
                              PasswordCriteriaRow(
                                criteriaMet: hasSpecialCharacter,
                                text: "Special characters",
                              ),
                            ],
                          );
                  }),
              const SizedBox(height: 20),
              PasswordField(
                inputType: TextInputType.text,
                validateMsg: '',
                controller: confirmpasswordController,
                title: "Confirm Password",
                hintText: 'Password',
                onValueChange: (val) {
                  if (val.isEmpty || getPasswordStrength() != 1.0) {
                    showControls.value = true;
                  } else {
                    showControls.value = false;
                  }
                },
              ),
              const Spacer(),
              CustomButton(
                title: 'Create Password',
                onTap: () {
                  if (getPasswordStrength() == 1.0) {
                    if (passwordTextController.text ==
                        confirmpasswordController.text) {
                      AppNavigationHelper.navigateToWidget(
                          context, PasswordResetSuccessful());
                    } else {
                      NotificationUtils.showToast(context,
                          message: "Password Mis-match");
                    }
                  }

                  print("${getPasswordStrength()}");
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
