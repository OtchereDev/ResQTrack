import 'dart:convert';

import 'package:resq_track/Core/Mixins/auth_base_repository.dart';
import 'package:resq_track/Core/Repositories/Profile/profile_repository.dart';
import 'package:resq_track/Core/app_constants.dart';

class ProfileService with AuthBaseRepository implements ProfileRepository {
  // @override
  // Future<User?> updateUser(context, User user) {
  //   // TODO: implement updateUser
  //   throw UnimplementedError();
  // }

  // Future getAllCountries(context) async {
  //   dynamic responseMap = {"status": false, "message": "", "data": null};
  //   await get(
  //     context,
  //     url: "$kBaseUrl/countries",
  //   ).then((response) {
  //     if (response != null) {
  //       var dataResponse = json.decode(response.body);
  //       if (response.statusCode == 200) {
  //         responseMap['status'] = true;
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = json.decode(response.body);
  //       } else {
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = dataResponse;
  //       }
  //     }
  //   });
  //   return responseMap;
  // }

  Future getUser(context) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/users/my-profile",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  // Future uploadProfilePic(context, data) async {
  //   dynamic responseMap = {"status": false, "message": "", "data": null};

  //   await put(
  //     context,
  //     url: "$kBaseUrl/user",
  //     data: (data)
  //   ).then((response) {
  //     print(response.body);

  //     if (response != null) {
  //       var dataResponse = json.decode(response.body);
  //       if (response.statusCode == 200) {
  //         responseMap['status'] = true;
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = json.decode(response.body);
  //       } else {
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = dataResponse;
  //       }
  //     }
  //   });
  //   return responseMap;
  // }

  // Future addTeamMember(context, data) async {
  //   dynamic responseMap = {"status": false, "message": "", "data": null};

  //   await post(
  //     context,
  //     url: "$kBaseUrl/invite-team-member",
  //     data: jsonEncode(data)
  //   ).then((response) {
  //     // print(response.body);

  //     if (response != null) {
  //       var dataResponse = json.decode(response.body);
  //       if (response.statusCode == 200) {
  //         responseMap['status'] = true;
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = json.decode(response.body);
  //       } else {
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = dataResponse;
  //       }
  //     }
  //   });
  //   return responseMap;
  // }

  //  Future getMembers(context) async {
  //   dynamic responseMap = {"status": false, "message": "", "data": null};

  //   await get(
  //     context,
  //     url: "$kBaseUrl/team-member",
  //   ).then((response) {
  //     if (response != null) {
  //       var dataResponse = json.decode(response.body);
  //       if (response.statusCode == 200) {
  //         responseMap['status'] = true;
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = json.decode(response.body);
  //       } else {
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = dataResponse;
  //       }
  //     }
  //   });
  //   return responseMap;
  // }


  Future replyChat(context, data) async {
  dynamic responseMap = {"status": false, "message": "", "data": null};
    await post(
      context,
      url: "$kBaseUrl/chat/message",
      data: jsonEncode(data)
    ).then((response) {
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
        var dataResponse = json.decode(response.body);
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else {
          responseMap['message'] = "Something went wrong";
          responseMap['data'] = null;
        }
      }
    });
    return responseMap;
  }

  
  Future initChat(context) async {
  dynamic responseMap = {"status": false, "message": "", "data": null};
    await post(
      context,
      url: "$kBaseUrl/chat",
    ).then((response) {
      if (response != null) {
        if (response.statusCode == 200 ||response.statusCode == 201) {
        var dataResponse = json.decode(response.body);
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else {
          responseMap['message'] = "Something went wrong";
          responseMap['data'] = null;
        }
      }
    });
    return responseMap;
  }


  Future getEmergencyContact(context) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await get(
      context,
      url: "$kBaseUrl/user/get-emergency-contact",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  Future updateEmergencyContact(context) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await get(
      context,
      url: "$kBaseUrl/users/update-emergency-contact",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  @override
  Future changePassword(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await post(context,
            url: "$kBaseUrl/users/reset-password", data: jsonEncode(data))
        .then((response) {
      // print(response.body);

      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  @override
  Future changePin(context, data) {
    // TODO: implement changePin
    throw UnimplementedError();
  }

  @override
  Future forgotPassword(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await post(context,
            url: "$kBaseUrl/users/forgot-password", data: jsonEncode(data))
        .then((response) {
      // print(response.body);

      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  @override
  Future updateProfile(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await patch(context,
            url: "$kBaseUrl/users/update-profile", data: (data))
        .then((response) {
      print(response.body);

      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  @override
  Future verifyForgotOtp(context, data) {
    // TODO: implement verifyForgotOtp
    throw UnimplementedError();
  }
}
