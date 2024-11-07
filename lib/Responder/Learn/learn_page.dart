import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/search_text.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Responder/Learn/quiz_question_page.dart';

class LearnPage extends StatelessWidget {
  LearnPage({super.key});

  final activeTabValue = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<ProfileProvider>(builder: (context, profile, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0, top: Platform.isIOS ? 0 : 20, right: 20),
                child: Text(
                  "Learn",
                  style: GoogleFonts.annapurnaSil(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.BLACK),
                ),
              ),
              AppSpaces.height20,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: activeTabValue,
                        builder: (context, isActive, _) {
                          return Row(
                            children: [
                              _tabButton(isActive == 0, "Video Tutorials", () {
                                activeTabValue.value = 0;
                              }),
                              AppSpaces.width8,
                              _tabButton(isActive == 1, "Quizzes", () {
                                activeTabValue.value = 1;
                              })
                            ],
                          );
                        }),
                    AppSpaces.height16,
                    ValueListenableBuilder(valueListenable: activeTabValue, builder: (context, isActive, _){
                      return isActive == 0 ? VideoTrainingTabView(): QuizTabView();
                    })
                  ],
                ),
              ),
            ]),
          );
        }),
      ),
    );
  }
}

class QuizTabView extends StatelessWidget {
  const QuizTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
      "Jump back in",
      style:
          TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    ),
    AppSpaces.height16,
    QuizeTile(),
    AppSpaces.height16,
    Text(
      "Jump back in",
      style:
          TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    ),
    AppSpaces.height16,
    ...List.generate(4, (index) {
      return QuizeTile(
        onTap: () {
          AppNavigationHelper.navigateToWidget(context, QuizPage());
        },
      );
    })
      ],
    );
  }
}

class QuizeTile extends StatelessWidget {
  final String? title, desc, score, percentage;
  final VoidCallback? onTap;
  const QuizeTile({
    super.key,
    this.title,
    this.desc,
    this.score,
    this.percentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.WHITE,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 4),
                    color: AppColors.BLACK.withOpacity(0.05),
                    blurRadius: 10)
              ]),
          child: Row(
            children: [
              Image.asset(
                'assets/images/quize_thumbnail.png',
                height: 75,
                width: 75,
              ),
              AppSpaces.width8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "First Aid Treatment",
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.BLACK),
                  ),
                  AppSpaces.height4,
                  Text("Lorem ipsum dolor sit ame...."),
                  AppSpaces.height4,
                  Text("Score: 0"),
                ],
              ),
              Expanded(child: Image.asset('assets/images/loading.png')),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoTrainingTabView extends StatelessWidget {
  const VideoTrainingTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 9,
                child: SizedBox(
                    height: 36, child: SearchText(search: (search) {}))),
            AppSpaces.width8,
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 0.6, color: AppColors.BLACK)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/icons/filter.svg'),
                  ),
                ),
              ),
            ),
          ],
        ),
        AppSpaces.height20,
        ...List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SizedBox(
              height: 150,
              child: Stack(
                children: [
                  ClipRRect(
                    child: Image.asset("assets/images/doc.png"),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "EMT Training Module",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.WHITE),
                      ))
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}

Widget _tabButton(bool isActive, String title, VoidCallback? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isActive ? AppColors.PRIMARY_COLOR : AppColors.WHITE,
          border: Border.all(
            color: isActive ? AppColors.PRIMARY_COLOR : Color(0xff667085),
          )),
      child: Center(
          child: Text(
        "$title",
        style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isActive ? AppColors.WHITE : Color(0xff667085)),
      )),
    ),
  );
}
