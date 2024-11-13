import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/alert_dailog.dart';
import 'package:resq_track/Components/passwordField.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Model/Response/emergency_response.dart';
import 'package:resq_track/Provider/Auth/login_provider.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Responder/Auth/SignUp/responder_signup.dart';
import 'package:resq_track/Responder/Home/responder_homee_page.dart';
import 'package:resq_track/Responder/Home/responder_index_page.dart';
import 'package:resq_track/Services/Firbase/auth_api.dart';
import 'package:resq_track/Views/Auth/ResetPasssword/forgot_password.dart';
import 'package:resq_track/Views/Home/index.dart';
import 'package:resq_track/Views/MapViews/map_view.dart';
import 'package:resq_track/Widgets/animate_icon.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class ResponderLoginPage extends StatelessWidget {
  ResponderLoginPage({super.key});

  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
   context.read<LocationProvider>().getCurrentLocation();
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<LocationProvider>(
          builder: (context, location, _) {
            return Consumer<AuthProvider>(builder: (context, auth, _) {
              return auth.loadPage ? const Center(child: CircularProgressIndicator(),): Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                           BlinkingSvg(forLogin: true,),
                         AppSpaces.height20,
                        Text(
                          "Login As Responder",
                          style: GoogleFonts.annapurnaSil(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Enter your login credentials",
                          style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                        AppSpaces.height20, //(height: 20),
                        AppSpaces.height20, //(height: 20),
                                
                        TextFormWidget(
                          emailcontroller,
                          'Email',
                          false,
                          hint: 'someone@mail.com',
                          validate: true,
                          validateEmail: true,
                          validateMsg: 'Email is required',
                        ),
                        AppSpaces.height20,
                        PasswordField(
                          inputType: TextInputType.text,
                          validateMsg: 'Password is required',
                          controller: passwordcontroller,
                          title: "Confirm Password",
                          hintText: 'Password',
                          validate: true,
                          onValueChange: (val) {},
                        ),
                        TextButton(
                          onPressed: () {
                            AppNavigationHelper.navigateToWidget(
                                context, ForgotPassword());
                          },
                          child: const Text(
                            "I’ve forgotten my password",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0xff0085FF)),
                          ),
                        ),
                        AppSpaces.height40,
                        CustomButton(
                          title: 'Login',
                          onTap: () {
                            if (formKey.currentState?.validate() == true) {
                              auth
                                  .performLogin(context,
                                      email: emailcontroller.text.trim(),
                                      password: passwordcontroller.text.trim())
                                  .then((value) {
                                if (value['status'] == true) {
                                  AuthApi().updateUserLocation(value['userID'],GeoPoint(location.latLong['lat'], location.latLong['lng']), location.locationMessage);
                                  alertDialog(
                                      title: "Login successful",
                                      message: "You can now go to home",
                                      isSuccess: true);
                                  AppNavigationHelper.setRootOldWidget(context, const ResponderBaseHomePage());
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                     Center(
                       child: TextButton(
                            onPressed: () {
                              AppNavigationHelper.navigateToWidget(
                                  context, SignUpPersonalDetails());
                            },
                            child: const Text(
                              "Signup as Responder",
                              style: TextStyle(
                                  // decoration: TextDecoration.underline,
                                  color: Color(0xff0085FF)),
                            ),
                          ),
                     ),
                      ],
                    ),
                  ),
                ),
              );
            });
          }
        ),
      ),
    );
  }
}
