import 'package:flutter/material.dart';
import 'package:resq_track/Components/alert_dailog.dart';
import 'package:resq_track/Model/Request/emergency_firebase_body.dart';
import 'package:resq_track/Model/Request/user_request.dart';
import 'package:resq_track/Model/Response/user_response.dart';
import 'package:resq_track/Services/Firbase/auth_api.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Services/Remote/Authentication/auth_remote_service.dart';
import 'package:resq_track/Utils/Dialogs/notifications.dart';

class AuthProvider extends ChangeNotifier {
  AuthRemoteService authService = AuthRemoteService();
  final SharedPrefManager _sharedPrefsManager = SharedPrefManager();
  bool _loadPage = false;
  bool get loadPage => _loadPage;

  setLoadingPage(bool value) {
    _loadPage = value;
    notifyListeners();
  }

  Future<bool> signUp(context,  user) async {
    bool? isResponder = await SharedPrefManager().getUserType();

  print("---------$isResponder--------------");
    setLoadingPage(true);
    bool isSuccess = false;
    await authService
        .signup(
      context,
      user.toJson(),
      isResponder
    )
        .then((value) {
      setLoadingPage(false);
      if (value['status'] == true) {
        isSuccess = true;
      } else {
        isSuccess = false;
        alertDialog(
          isSuccess: false,
          message: value['message'].toString(),
          title: 'Failed',
        );
      }
    });
    return isSuccess;
  }

  Future<Map<String, dynamic>> performLogin(context,
      {required String email, required String password}) async {
    setLoadingPage(true);

    String? token = await SharedPrefManager().getPushNotificationToken();
   bool  isResponder = await SharedPrefManager().getUserType()    ;
     Map<String, dynamic>? actionSuccessful = {"status":false, "userID":""};
    Map<String, dynamic> data = {
      "email": email,
      "password": password,
    };
    await authService.signin(context, data,isResponder ).then((response) async {
      setLoadingPage(false);
      if (response['status'] == true) {
        var user = User.fromJson(response['data']['user']);
        await _sharedPrefsManager
            .setAuthToken(response['data']['access_token']);
        await _sharedPrefsManager.setUser(user);
        if (!isResponder) {
          await _sharedPrefsManager.setEmergency(
              User.fromJson(response['data']['emergency_contact']));
        }
        AuthApi().createUser(
            user: UserFirebaseRequest(
                fcmToken: token ?? "",
                userId: user.id ?? "",
                name: user.name ?? "",
                userType:isResponder ? "Responder": "Normal"));

        actionSuccessful['status'] = true;
        actionSuccessful['userID'] = user.id;
      } else {
        alertDialog(
            title: 'Login failed',
            message: response['message'].toString(),
            isSuccess: false);
      }
    });
    return actionSuccessful;
  }

  // Future<bool> requestAccess(
  //     context, RequestAccessRequestModel requestModel) async {
  //   setLoadingPage(true);
  //   await authService.signup(context, requestModel.toJson()).then((value) {
  //     setLoadingPage(false);
  //     if (value['status'] == true) {
  //       noti(title: 'Success', message: value['message']);
  //       Get.back();
  //     } else {
  //       NotificationUtils.showToast(context, message: value['message']);
  //     }
  //   });
  //   return false;
  // }

  Future<bool?> sendOtp(context, {required String? email}) async {
    bool actionSuccessful = false;
    setLoadingPage(true);
    await authService.sendOtp(context, {'email': email!}).then((response) {
      setLoadingPage(false);
      if (response != null) {
        if (response['status'] == true) {
          actionSuccessful = true;
          NotificationUtils.showToast(context,
              message: response['data']['message'].toString());
        } else {
          alertDialog(
              title: "An error Occurred",
              message: response['message'].toString(),
              isSuccess: false);
        }
      }
    });
    return actionSuccessful;
  }

  Future<bool> verifyOtp(context,
      {required String phone, required String code}) async {
    bool actionSuccessful = false;
    Map<String, dynamic> data = {"email": phone, "otp": code};
    setLoadingPage(true);

    await authService.verifyOtp(context, data).then((response) async {
      print(response);
      setLoadingPage(false);

      if (response != null) {
        // session expired
        if (response['status'] == false) {
          return false;
        }
        if (response['status'] == true) {
          // AppNavigationHelper.setRootOldWidget(context, LoginScreen());
          // subscribePushNotification(context);
          actionSuccessful = true;
        } else {
          // DialogUtils.showNativeAlertDialog(context,
          //     title: "An error Occurred",
          //     message: response['data']['message'].toString());
        }
      }
    });
    return actionSuccessful;
  }

  // checkPhone(context, dynamic data) async {
  //   setLoadingState(LoadingState.busy);
  //   await authService.setPin(context, data).then((response) {
  //     setLoadingState(LoadingState.idle);
  //     if (response['status'] == true) {
  //       // AppNavigationHelper.navigateToWidget(
  //       //     context, ForgotPassVerifyScreen(phoneNumber: data['phone']));
  //     } else {
  //       // DialogUtils.showNativeAlertDialog(context,
  //       //     title: "Sorry", message: response['message'].toString());
  //     }
  //   });
  //   setLoadingState(LoadingState.idle);
  // }

  // Future<bool> verifyForgotOtp(context, String code, String password,
  //     String confirmPassword, String email) async {
  //   bool isSuccess = false;
  //   Map<String, dynamic> body = {
  //     "email": email,
  //     "otp": code,
  //     "new_password": password,
  //     "confirm_password": confirmPassword
  //   };
  //   setLoadingPage(true);
  //   await authService.resetPassword(context, body).then((value) async {
  //     setLoadingPage(false);
  //     if (value['status'] == true) {
  //       isSuccess = true;
  //        customDailog(
  //           isSuccess: true, title: 'Success', message: value['message']);
  //     } else {
  //       customDailog(
  //           isSuccess: false, title: 'Failed', message: value['message']);
  //     }
  //   });

  //   return isSuccess;
  // }

  // subscribePushNotification(context) async {
  //   String deviceToken = await SharedPrefsManager().getPushNotificationToken();
  //   Map<String, dynamic> body = {"handle": deviceToken};
  //   await authService.subscribePushNotification(context, body);
  // }

  // testNotification(context) async {
  //   authService.testPushNotification(context, "data");
  // }
}
