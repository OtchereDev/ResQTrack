import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq_track/Components/alert_dailog.dart';
import 'package:resq_track/Model/Response/user_response.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:resq_track/Services/Remote/Profile/profile_service.dart';
import 'package:resq_track/Utils/Dialogs/notifications.dart';

class ProfileProvider extends ChangeNotifier {
  final SharedPrefManager _sharedPrefsManager = SharedPrefManager();
  final ProfileService _profileService = ProfileService();
  User? _currentUserProfile;
  User? get currentUserProfile => _currentUserProfile;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _profileImage;
  XFile? get profileImage => _profileImage;

  void setCurrentUserProfile(User user) {
    _currentUserProfile = user;
    // print("setting current user to shared Prefs ${user.toJson()}");
    _sharedPrefsManager.setUser(user);
    notifyListeners();
  }

  resetUser(context) async {
    await getUser(context);
  }

  String getUserFullname() {
    String fullName = "";
    if (_currentUserProfile != null) {
      fullName = "${_currentUserProfile!.name}";
    }
    return fullName;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  getUser(context, {bool fromRemote = false}) async {
    User? user;
    if (fromRemote) {
      user = await getRemoteUser(context);
    }

    user = await _sharedPrefsManager.getUser();

    if (user != null) {
      setCurrentUserProfile(user);
    }
    return user;
  }

  ProfileProvider(context) {
    loadCurrentProfile(context);
  }

  Future<User?> loadCurrentProfile(context) async {
    getUser(context);
    return null;
  }

  Future logout(context) async {
    await _sharedPrefsManager.logout();
    _currentUserProfile = null;
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

  _setImage(CroppedFile value) {
    _profileImage = XFile(value.path);
    // _convertImageToBase(_profileImage!);
    notifyListeners();
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

  Future<bool> changePassword(context, String password, String newPassword,
      String confirmPassword) async {
    bool isSuccess = false;
    if (newPassword != confirmPassword) {
      alertDialog(
          title: 'Sorry', message: 'Password mis-match', isSuccess: false);
    } else {
      setLoading(true);
      Map<String, dynamic> body = {
        "confirm_password": confirmPassword,
        "new_password": newPassword,
        "password": password
      };
      await _profileService
          .changePassword(context, jsonEncode(body))
          .then((response) {
        setLoading(false);
        if (response['status'] == true) {
          isSuccess = true;
          alertDialog(
              message: response['message'],
              title: "Update Complete",
              isSuccess: true);
        } else if (response['status'] == 401) {
          NotificationUtils.showToast(context, message: 'Logging out user');
        } else {
          // print("==========================${response}");
          alertDialog(
              message: response['message'],
              title: "An Error Occurred.",
              isSuccess: false);
        }
      });
    }
    return isSuccess;
  }

  Future<bool> forgotPassword(context, String password, String newPassword,
      String confirmPassword) async {
    bool isSuccess = false;
    if (newPassword != confirmPassword) {
      alertDialog(
          title: 'Sorry', message: 'Password mis-match', isSuccess: false);
    } else {
      setLoading(true);
      Map<String, dynamic> body = {
        "confirm_password": confirmPassword,
        "new_password": newPassword,
        "password": password
      };
      await _profileService.forgotPassword(context, body).then((response) {
        setLoading(false);
        if (response['status'] == true) {
          isSuccess = true;
          alertDialog(
              message: response['message'],
              title: "Update Complete",
              isSuccess: true);
        } else if (response['status'] == 401) {
          NotificationUtils.showToast(context, message: 'Logging out user');
        } else {
          // print("==========================${response}");
          alertDialog(
              message: response['message'],
              title: "An Error Occurred.",
              isSuccess: false);
        }
      });
    }
    return isSuccess;
  }

  Future<bool> updateProfile(context, String name, String phoneNumber) async {
    bool isSuccess = false;

    setLoading(true);
    Map<String, dynamic> body = {"name": name, "phoneNumber": phoneNumber};
    await _profileService.updateProfile(context, body).then((response) {
      setLoading(false);
      if (response['status'] == true) {
        isSuccess = true;
        alertDialog(
            message: response['message'],
            title: "Update Complete",
            isSuccess: true);
      } else if (response['status'] == 401) {
        NotificationUtils.showToast(context, message: 'Logging out user');
      } else {
        // print("==========================${response}");
        alertDialog(
            message: response['message'],
            title: "An Error Occurred.",
            isSuccess: false);
      }
    });

    return isSuccess;
  }

  Future<User?> getRemoteUser(context) async {
    setLoading(true);
    User? newUser;
    await _profileService.getUser(context).then((response) async {
      setLoading(false);
      if (response['status'] == true) {
        newUser = User(
            createdAt: DateTime.tryParse(response['data']['data']['createdAt']),
            email: response['data']['data']['email'],
            phoneNumber: response['data']['data']['phoneNumber'],
            name: response['data']['data']['name'],
            id: response['data']['data']['_id']);
        await _sharedPrefsManager.setUser(newUser!);
      } else if (response['status'] == 401) {
        NotificationUtils.showToast(context, message: 'Logging out user');
      } else {
        // print("==========================${response}");
        alertDialog(
            message: response['message'],
            title: "An Error Occurred.",
            isSuccess: false);
      }
    });
    return newUser;
  }
}
