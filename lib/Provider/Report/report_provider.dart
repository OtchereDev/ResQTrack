import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq_track/Components/alert_dailog.dart';
import 'package:resq_track/Model/Request/emergency_m.dart';
import 'package:resq_track/Model/Request/emergency_request_body.dart';
import 'package:resq_track/Model/Response/emergency_response.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Services/Remote/Emergency/emergency_service.dart';
import 'package:resq_track/Utils/utils.dart';

class ReportProvider extends ChangeNotifier {
  final emergencyServices = EmergencyService();
  final List<XFile> _images = [];
  List<XFile> get images => _images;
  EmergencyResponse _emergencyResponse = EmergencyResponse();

  EmergencyResponse get emergencyRes => _emergencyResponse;
  EmergencyEmergency _emergency = EmergencyEmergency();

  EmergencyEmergency get singleEmergency => _emergency;
  List<EmergencyMod> _emModel = [];
  List<EmergencyMod> get emModel => _emModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool load) {
    _isLoading = load;
    notifyListeners();
  }

  void setShops(List<EmergencyMod> shops) {
    _emModel = shops;
    notifyListeners();
  }

  void selectProfileImages() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
      imageQuality: 60,
    );
    _cropImage(image?.path);
  }

  Future<void> _cropImage(filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,

      // aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
    );

    if (croppedFile != null) {
      _setImage(croppedFile);
    }
  }

  _setImage(CroppedFile value) {
    _images.add(XFile(value.path));
    notifyListeners();
  }

  Future<bool> createEmergency(context, EmergencyRequest data) async {
    bool isSuccess = false;
    // setLoading(true);
    await emergencyServices.createReport(context, data).then((res) {
      print("----------Response--------${res['data']['data']}");

      setLoading(false);
      if (res['status'] == true) {
        alertDialog(title: 'Success', message: res['message'], isSuccess: true);
        String? emergency_id = res['data']['data']['emergency']['_id'];
        print("=========================$emergency_id===================");
        SharedPrefManager().setActiveEmergency(emergency_id ?? "");
        _images.clear();
        isSuccess = true;

        notifyListeners();
      } else {
        alertDialog(
            title: 'Failed', message: res['message'][0], isSuccess: false);
      }
    });

    return isSuccess;
  }

  Future<List<String>> uploadImage(context) async {
    List<String> isSuccess = [];
    setLoading(true);
    var files = [];
    for (var image in _images) {
      var file = await Utils.convertImageToBase64(image.path);
      files.add(file);

      notifyListeners();
    }
    Map<String, dynamic> body = {"photos": files};

    await emergencyServices.uploadEmergencyPhoto(context, body).then((res) {
      print("----------------$res---------------");
      // setLoading(false);
      if (res['status'] == true) {
        isSuccess = List<String>.from(res['data']['data']['urls']);
        alertDialog(title: 'Success', message: "Success", isSuccess: true);
      } else {
        setLoading(false);

        alertDialog(
            title: 'Failed', message: res['message'][0], isSuccess: false);
      }
    });

    return isSuccess;
  }

  getEmergencyReport(context) async {
    setLoading(true);
    await emergencyServices.getReport(context).then((res) {
      setLoading(false);
      if (res['status'] == true) {
        _emergencyResponse = EmergencyResponse.fromJson(res['data']);
        notifyListeners();
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
  }

  getEmergencyReportById(context, id) async {
    // setLoading(true);
    await emergencyServices.getReportById(context, id).then((res) {
      // setLoading(false);
      if (res['status'] == true) {
        debugPrint("-----------------${res}-----------");
        _emergency = EmergencyEmergency.fromJson(res['data']['emergency']);
        notifyListeners();
      } else {
        alertDialog(title: 'Failed', message: res['message'], isSuccess: false);
      }
    });
  }

  getDashboardData(context) async {
     setLoading(true);
    await emergencyServices.getDashboardData(
        context, {"location": "0.83663, -3.008474"}).then((response) {
                setLoading(false);
      if (response['status'] == true) {}else {
        alertDialog(title: 'Failed', message: response['message'], isSuccess: false);
      }
    });
  }
}
