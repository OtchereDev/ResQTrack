import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Responder/Learn/comaplete_quiz.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';


class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Sample questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'In the incident of a burn, what is the first action to take to help the victim?',
      'options': ['Option A', 'Option B', 'Option C', 'Option D'],
      'selectedOption': -1,
    },
    {
      'question': 'In the incident of a burn, what is the first action to take to help the victim?',
      'options': ['Option A', 'Option B', 'Option C', 'Option D'],
      'selectedOption': -1,
    },
    {
      'question': 'In the incident of a burn, what is the first action to take to help the victim?',
      'options': ['Option A', 'Option B', 'Option C', 'Option D'],
      'selectedOption': -1,
    },
    {
      'question': 'In the incident of a burn, what is the first action to take to help the victim?',
      'options': ['Option A', 'Option B', 'Option C', 'Option D'],
      'selectedOption': -1,
    },
    // Add more questions here
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.height16,
               const BackArrowButton(),
                AppSpaces.height20,
                AppSpaces.height20,
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_questions.length, (index){
                  return Padding(
                    padding: const EdgeInsets.only(left:3.0, right: 3),
                    child: Container(
                                height: 5,
                                width: (Utils.screenWidth(context) / _questions.length)- 20 ,
                                decoration: BoxDecoration(
                                  color: _currentPage == index ?  AppColors.PRIMARY_COLOR : Color(0xffD0D5DD),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                               ),
                  );
                }),
               ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _questions.length,
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
                        onTap:_currentPage < 1 ? ()=> Navigator.pop(context): _previousPage,
                        title: ('Back'),
                      ),
                    ),
                    AppSpaces.width8,
                  // if (_currentPage < _questions.length - 1)
                    Expanded(
                      child: CustomButton(
                        onTap: _currentPage < _questions.length - 1 ? _nextPage : ()=>AppNavigationHelper.navigateToWidget(context, CompletedQuizPage()),
                        title: ('Next'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionPage(int index) {
    final question = _questions[index];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          SizedBox(height: 24),
          // Center(
          //   child: Image.asset('assets/burn_first_aid.png', height: 200), // Replace with your image
          // ),
          SizedBox(height: 24),
          Text(
            '${index + 1}. ${question['question']}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...List.generate(question['options'].length, (optionIndex) {
            return RadioListTile(

              title: Text(question['options'][optionIndex]),
              value: optionIndex,
              groupValue: question['selectedOption'],
              onChanged: (value) {
                setState(() {
                  _questions[index]['selectedOption'] = value;
                });
              },
            );
          }),
        ],
      ),
    );
  }
}
