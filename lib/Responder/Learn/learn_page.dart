import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/image_viewer.dart';
import 'package:resq_track/Components/search_text.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Responder/Learn/quiz_question_page.dart';
import 'package:resq_track/Responder/Learn/tutotial_view.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Utils/utils.dart';
class LearnPage extends StatefulWidget {
  LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final activeTabValue = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.value([
      Provider.of<ResponderProvider>(context, listen: false).getQuiz(context),
      Provider.of<ResponderProvider>(context, listen: false).getTutorial(context),

      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<ProfileProvider>(builder: (context, profile, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        },
                      ),
                      AppSpaces.height16,
                      ValueListenableBuilder(
                        valueListenable: activeTabValue,
                        builder: (context, isActive, _) {
                          return isActive == 0 ?
                              VideoTrainingTabView()
                             :  QuizTabView();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}


class QuizTabView extends StatelessWidget {
  const QuizTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResponderProvider>(
      builder: (context, responder, _) {
        final quizzes = responder.quizesResponse?.data?.quizes ?? [];

        return responder.isLoading ? LoadingPage(): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jump back in",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
           
            AppSpaces.height16,
            ListView.builder(
              shrinkWrap: true,
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                var question = quizzes[index];
                return QuizeTile(
                  key: ValueKey(question.id),
                  desc: question.description ?? "",
                  title: question.title,
                  percentage: question.image,
                  onTap: () {
                    AppNavigationHelper.navigateToWidget(context, QuizPage(quizeId: question.id,));
                  },
                );
              },
            ),
          ],
        );
      },
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
      padding: const EdgeInsets.only(bottom: 15.0),
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
              ImageViewer(
                url: percentage??"",
                height: 75,
                width: 75,
              
              ),
              AppSpaces.width8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title??"",
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.BLACK),
                  ),
                  AppSpaces.height4,
                  SizedBox(
                    width: Utils.screenWidth(context)-170,
                    child: Text(desc??"", maxLines: 1,style: TextStyle(overflow: TextOverflow.ellipsis), )),
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
