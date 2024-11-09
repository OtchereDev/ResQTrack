import 'package:flutter/foundation.dart';
import 'package:resq_track/Components/alert_dailog.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Request/answer_request.dart';
import 'package:resq_track/Model/Response/guide_response_mode.dart';
import 'package:resq_track/Model/Response/home_dashboard.dart';
import 'package:resq_track/Model/Response/questionResponse.dart';
import 'package:resq_track/Model/Response/quizResponse.dart';
import 'package:resq_track/Model/Response/responder_respond_model.dart';
import 'package:resq_track/Services/Remote/Responder/emergency_service.dart';

class ResponderProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final emergencyServices = ResponderService();

  ResponderRequestModel _emergencyResponse = ResponderRequestModel();
  ResponderRequestModel get emergencyRes => _emergencyResponse;

  QuestionResponse? _questionResponse;
  QuestionResponse? get questionResponse => _questionResponse;

  Metric? _homeMetrics;
  Metric? get homeMetrics => _homeMetrics;

  GuideResponse? _guideResponse;
  GuideResponse? get guideData => _guideResponse;

  QuizesResponse? _quizesResponse;
  QuizesResponse? get quizesResponse => _quizesResponse;

  dynamic _score = "0";
  dynamic get score => _score;

  List<Answer> _answer = [];
  List<Answer> get answer => _answer;

  Guide? _guide;
  Guide? get singleGuide => _guide;

  var _travelTimeText;
  get travelTimeText => _travelTimeText;

  setLoading(bool load) {
    _isLoading = load;
    notifyListeners();
  }

  void setAnswer(Answer newAnswer) {
    final index =
        _answer.indexWhere((an) => an.questionId == newAnswer.questionId);
    if (index != -1) {
      _answer[index] = newAnswer;
    } else {
      _answer.add(newAnswer);
    }

    notifyListeners();
  }

  getEmergencyReportById(context, id) async {
    setLoading(true);
    await emergencyServices.getResponderReportById(context, id).then((res) {
      setLoading(false);
      if (res['status'] == true) {
        _emergencyResponse = ResponderRequestModel.fromJson(res['data']);
        notifyListeners();
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
  }

  getQuiz(context) async {
    setLoading(true);
    await emergencyServices.getQuestions(context).then((res) {
      print(res);
      setLoading(false);
      if (res['status'] == true) {
        _quizesResponse = QuizesResponse.fromJson(res['data']);
        notifyListeners();
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
  }

  getQuestionsDetails(context, id) async {
    setLoading(true);
    await emergencyServices.getQuestionsDetails(context, id).then((res) {
      setLoading(false);
      if (res['status'] == true) {
        _questionResponse = QuestionResponse.fromJson(res['data']);
        notifyListeners();
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
  }

  Future<bool> answerQuestion(context, String quizId) async {
    // setLoading(true);
    bool isSuccess = false;
    AnswerResponse _answersReq =
        AnswerResponse(answers: _answer, quizId: quizId);
    await emergencyServices
        .answerQuestions(context, _answersReq.toJson())
        .then((res) {
      print(res);
      setLoading(false);
      if (res['status'] == true) {
        isSuccess = true;
        _score = (res['data']['data']['correctCount'] /
                res['data']['data']['totalCount']) *
            100;

        notifyListeners();
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
    return isSuccess;
  }

  acceptRequest(context, id) async {
    setLoading(true);
    await emergencyServices.acceptRide(context, id).then((res) {
      setLoading(false);
      if (res['status'] == true) {
        alertDialog(title: 'Success', message: res['message'], isSuccess: true);
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
  }

  responderArrive(context, id) async {
    setLoading(true);
    await emergencyServices.acceptRide(context, id).then((res) {
      setLoading(false);
      if (res['status'] == true) {
        alertDialog(title: 'Success', message: res['message'], isSuccess: true);
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
  }

  responderComplete(context, id) async {
    setLoading(true);
    await emergencyServices.completeRide(context, id).then((res) {
      setLoading(false);
      if (res['status'] == true) {
        alertDialog(title: 'Success', message: res['message'], isSuccess: true);
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
  }

  getDashboardData(context) async {
    setLoading(true);
    await emergencyServices.getResponderDashboard(
        context, {"location": "0.83663, -3.008474"}).then((response) {
      setLoading(false);
      if (response['status'] == true) {
        _homeMetrics = Metric.fromJson(response['data']['data']['metric']);
        notifyListeners();
      } else {
        alertDialog(
            title: 'Failed', message: response['message'], isSuccess: false);
      }
    });
  }

  getGuide(context) async {
    setLoading(true);
    await emergencyServices.getGuideData(context).then((response) {
      // print("------Response------$response----------------");
      setLoading(false);
      if (response['status'] == true) {
        _guideResponse = GuideResponse.fromJson(response['data']);
        notifyListeners();
      } else {
        alertDialog(
            title: 'Failed', message: response['message'], isSuccess: false);
      }
    });
  }

  getSingleGuide(context, id) async {
    setLoading(true);
    await emergencyServices.getSingleGuideData(context, id).then((response) {
      setLoading(false);
      if (response['status'] == true) {
        _guide = Guide.fromJson(response['data']['data']['guide']);
        notifyListeners();
      } else {
        alertDialog(
            title: 'Failed', message: response['message'], isSuccess: false);
      }
    });
  }

  Future<void> calculateETA(context, String origin, String destination) async {
    await emergencyServices
        .getETA(context, newApiKey, origin, destination)
        .then((response) {
      if (response['status'] == true && response['data']['status'] == "OK") {
        final durationInTraffic =
            response['data']['routes'][0]['legs'][0]['duration_in_traffic'];
        final duration = response['data']['routes'][0]['legs'][0]['duration'];

        final travelTime = durationInTraffic ?? duration;

        _travelTimeText = travelTime['text'];
        notifyListeners();

        return travelTimeText;
      }
    });
  }
}
