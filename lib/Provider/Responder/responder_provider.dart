import 'package:flutter/foundation.dart';
import 'package:resq_track/Components/alert_dailog.dart';
import 'package:resq_track/Model/Response/home_dashboard.dart';
import 'package:resq_track/Model/Response/responder_respond_model.dart';
import 'package:resq_track/Services/Remote/Responder/emergency_service.dart';

class ResponderProvider with ChangeNotifier{
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final emergencyServices = ResponderService();

  ResponderRequestModel _emergencyResponse = ResponderRequestModel();

    ResponderRequestModel get emergencyRes => _emergencyResponse;

    Metric? _homeMetrics;
    Metric? get homeMetrics => _homeMetrics;




  setLoading(bool load){
    _isLoading = load;
    notifyListeners();
  }

  

  getEmergencyReportById(context, id) async {
    setLoading(true);
    await emergencyServices.getResponderReportById(context, id).then((res) {
      setLoading(false);
      if (res['status'] == true) {
        debugPrint("-----------------${res}-----------");
        _emergencyResponse = ResponderRequestModel.fromJson(res['data']);
        notifyListeners();
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
  }

   acceptRequest(context, id) async {
    setLoading(true);
    await emergencyServices.acceptRide(context, id).then((res) {
      setLoading(false);
      if (res['status'] == true) {
        debugPrint("-----------------${res}-----------");
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
        debugPrint("-----------------${res}-----------");
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
          print("------Response------$response----------------");
                setLoading(false);
      if (response['status'] == true) {
        _homeMetrics = Metric.fromJson(response['data']['data']['metric']);
        notifyListeners();
      }else {
        alertDialog(title: 'Failed', message: response['message'], isSuccess: false);
      }
    });
  }
}

