import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resq_track/Core/Mixins/auth_base_repository.dart';
import 'package:resq_track/Core/Repositories/Auth/auth_repository.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';

class AuthRemoteService with AuthBaseRepository implements AuthRepository {
  @override
  String token = "N/A";
  // SharedPrefsManager _manager = new SharedPrefsManager();

  @override
  Future<Map<String, String>> setHeaders({bool? isFcm = false}) async {
    token = await SharedPrefManager().getAuthToken();
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  // registers device for firebase notifications
  @override
  Future<bool> registerDevice(String token) async {
    try {
      Map<String, String> headers = await setHeaders();
      var data = {'device_token': token};

      var response = await http.post(Uri.parse(kBaseUrl),
          body: jsonEncode(data), headers: headers);
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> signin(context, data, bool isResponder) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await post(
      context,
      url: "$kBaseUrl/auth/${isResponder ? 'login-responder' : 'login'}",
      data: jsonEncode(data),
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  @override
  Future<dynamic> signup(context, data, isResponder) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    print(data);
    await post(
      context,
      url: "$kBaseUrl/${isResponder ? "responders/create" : "users/create"}",
      data: jsonEncode(data),
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
      // print(responseMap);
    });
    return responseMap;
  }

  Future checkAuthToken(context) async {
    dynamic responseMap;
    var resp = await get(context, url: "$kBaseUrl/auth/check");
    if (resp != null) responseMap = json.decode(resp.body);
    return responseMap;
  }

  @override
  Future sendOtp(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await post(
      context,
      url: "$kBaseUrl/users/create",
      data: jsonEncode(data),
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
      // print(responseMap);
    });
    return responseMap;
  }

  @override
  Future verifyOtp(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await post(
      context,
      url: "$kBaseUrl/users/create",
      data: jsonEncode(data),
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
      // print(responseMap);
    });
    return responseMap;
  }
}
