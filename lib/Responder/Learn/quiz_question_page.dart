import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Model/Request/answer_request.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Responder/Learn/comaplete_quiz.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';

class QuizPage extends StatefulWidget {
  final String quizeId;

  const QuizPage({super.key, required this.quizeId});
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    var pro = Provider.of<ResponderProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pro.getQuestionsDetails(context, widget.quizeId);
    });
  }

  // Sample questions

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    var pro = Provider.of<ResponderProvider>(context, listen: false);

    if (_currentPage <
        pro.questionResponse!.data!.quiz!.questions!.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var pro = context.read<ResponderProvider>();

    //    final List<Map<String, dynamic>> _questions = [
    //   {
    //     'question': 'In the incident of a burn, what is the first action to take to help the victim?',
    //     'options': ['Option A', 'Option B', 'Option C', 'Option D'],
    //     'selectedOption': -1,
    //   },
    //   {
    //     'question': 'In the incident of a burn, what is the first action to take to help the victim?',
    //     'options': ['Option A', 'Option B', 'Option C', 'Option D'],
    //     'selectedOption': -1,
    //   },
    //   {
    //     'question': 'In the incident of a burn, what is the first action to take to help the victim?',
    //     'options': ['Option A', 'Option B', 'Option C', 'Option D'],
    //     'selectedOption': -1,
    //   },
    //   {
    //     'question': 'In the incident of a burn, what is the first action to take to help the victim?',
    //     'options': ['Option A', 'Option B', 'Option C', 'Option D'],
    //     'selectedOption': -1,
    //   },
    //   // Add more questions here
    // ];
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<ResponderProvider>(builder: (context, provider, _) {
          var qust = provider.questionResponse?.data?.quiz?.questions;

          return provider.isLoading
              ? const LoadingPage()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpaces.height16,
                      const BackArrowButton(),
                      AppSpaces.height20,
                      AppSpaces.height20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(qust?.length ?? 0, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 3.0, right: 3),
                            child: Container(
                              height: 5,
                              width:
                                  (Utils.screenWidth(context) / qust!.length) -
                                      20,
                              decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? AppColors.PRIMARY_COLOR
                                      : const Color(0xffD0D5DD),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          );
                        }),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: qust?.length ?? 0,
                          itemBuilder: (context, index) {
                            return _buildQuestionPage(index);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // if (_currentPage > 0)
                          Expanded(
                            child: CustomOutlinedButton(
                              onTap: _currentPage < 1
                                  ? () => Navigator.pop(context)
                                  : _previousPage,
                              title: ('Back'),
                            ),
                          ),
                          AppSpaces.width8,
                          Expanded(
                            child: CustomButton(
                              onTap: _currentPage < qust!.length - 1
                                  ? _nextPage
                                  : () {
                                      pro.answerQuestion(context, widget.quizeId).then((val) {
                                        if (val == true) {
                                          AppNavigationHelper.navigateToWidget(
                                              context,
                                              const CompletedQuizPage());
                                        }
                                      });
                                    },
                              title: ('Next'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  Widget _buildQuestionPage(int index) {
    return Consumer<ResponderProvider>(builder: (context, responder, _) {
      final question =
          responder.questionResponse!.data?.quiz?.questions?[index];

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Center(
            //   child: Image.asset('assets/burn_first_aid.png', height: 200), // Replace with your image
            // ),
            const SizedBox(height: 24),
            Text(
              '${index + 1}. ${question!.question}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(question.options?.length ?? 0, (optionIndex) {
              return RadioListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                    "${question.options?[optionIndex].symbol} - ${question.options?[optionIndex].answer}"),
                value: optionIndex,
                groupValue: question.selectedOption,
                onChanged: (value) {
                  responder.setAnswer(Answer(
                      answer: question.options?[optionIndex].symbol,
                      questionId: question.sId));
                  setState(() {
                    question.selectedOption = value;
                  });
                },
              );
            }),
          ],
        ),
      );
    });
  }
}
