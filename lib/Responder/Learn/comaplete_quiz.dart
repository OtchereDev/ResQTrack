import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Responder/Home/responder_index_page.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class CompletedQuizPage extends StatelessWidget {
  const CompletedQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.WHITE,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset("assets/icons/medal.svg"),
            AppSpaces.height40,
          
            AppSpaces.height40,
          
            Text("Perfect lesson!", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.PRIMARY_COLOR),),
            AppSpaces.height40,
            const Text("You did it. You passed the First Aid Treatment \nquiz in one try!",textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.BLACK),),
            AppSpaces.height20,
            SvgPicture.asset("assets/icons/full_load.svg",),
            const Spacer(),
            CustomButton(title: 'Done', onTap: (){
              AppNavigationHelper.setRootOldWidget(context, const ResponderBaseHomePage(initialIdex: 1,));
            },),
            AppSpaces.height20,
          
          
            ],
          ),
        ),
      ),
    );
  }
}