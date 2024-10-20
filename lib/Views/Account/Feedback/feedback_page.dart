import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Views/Notification/notification_page.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({super.key});

  final answersValueNotifier = ValueNotifier(0);
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackArrowButton(),
              AppSpaces.height20,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Feedback",
                        style: GoogleFonts.annapurnaSil(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      AppSpaces.height20,
                      textHeader("Send Feedback"),
                      AppSpaces.height20,
                      const Text(
                        "What has been your experience using the app",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                      AppSpaces.height8,
                      ValueListenableBuilder(
                          valueListenable: answersValueNotifier,
                          builder: (context, answer, _) {
                            return Wrap(
                              spacing: 10,
                              runSpacing: 15,
                              children: List.generate(_answers.length, (index) {
                                return CustomChip(
                                    isActive: answer == index,
                                    title: _answers[index]);
                              }),
                            );
                          }),
                      AppSpaces.height20,
                      const Text(
                        "What suggestions do you have for us?",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                      AppSpaces.height8,
                      TextFormWidget(
                        textController,
                        '',
                        false,
                        line: 7,
                        hint: 'Type your suggestion here',
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(
          title: 'Send Feedback',
          onTap: () {},
        ),
      ),
    );
  }
}

List<String> _answers = [
  "Selected Answer",
  "Answer",
  "Answer",
  "Answer",
  "Answer",
  "Answer",
  "Answer",
  "Answer",
  "Answer",
];
