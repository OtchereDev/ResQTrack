import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Responder/Auth/Login/login.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Views/Auth/Login/login.dart';
import 'package:resq_track/Views/Auth/SignUp/signup.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';

class GetStartedPage extends StatelessWidget {
  GetStartedPage({super.key});

  final imageIndex = ValueNotifier<int>(0);
  final controller = PageController(initialPage: 0);

  final List<String> imgList = ["ambulance", "fire", "police"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                AppSpaces.height40,
                Text(
                  "ResQTrack",
                  style: GoogleFonts.annapurnaSil(
                    fontSize: 39, 
                    fontWeight: FontWeight.w700
                  ),
                ),
                AppSpaces.height20,
                const Text(
                  "Quick emergency response in the palm \nof your hands",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.DEFAULT_TEXT,
                  ),
                ),
                AppSpaces.height40,
                ValueListenableBuilder<int>(
                  valueListenable: imageIndex,
                  builder: (context, image, _) {
                    return Expanded(
                      child: PageView.builder(
                        controller: controller,
                        itemCount: imgList.length,
                        itemBuilder: (context, index) {
                          return SvgPicture.asset(
                            'assets/icons/${imgList[index]}.svg',
                          // / Ensure the image is large but fits
                          );
                        },
                        onPageChanged: (value) {
                          imageIndex.value = value;
                        },
                      ),
                    );
                  },
                ),
                AppSpaces.height40,
                ValueListenableBuilder<int>(
                  valueListenable: imageIndex,
                  builder: (context, imageNo, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imgList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: imageNo == index
                                  ? AppColors.BLACK
                                  : Colors.transparent,
                              border: Border.all(
                                  width: 1, color: AppColors.BLACK),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                AppSpaces.height40,
                TextButton(onPressed: (){
                  SharedPrefManager().setUserType(true);
                  AppNavigationHelper.navigateToWidget(context, ResponderLoginPage());
                }, child: Text("As Responder")),
                AppSpaces.height40,

                CustomButton(
                  title: "Sign Up",
                  onTap: () {
                    AppNavigationHelper.navigateToWidget(context, SignUpPersonalDetails());
                  },
                ),
                AppSpaces.height16,
           
                SizedBox(
                           height: 50,
                  child: CustomOutlinedButton(
                     title: "Login",
                    onTap: () {
                      AppNavigationHelper.navigateToWidget(context, LoginPage());
                    },
                  ),
                ),
                AppSpaces.height20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

