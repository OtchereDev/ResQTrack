import 'dart:convert';

import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Core/Mixins/auth_base_repository.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Views/GetStarted/get_started.dart';
import 'package:provider/provider.dart';

class ResponderService with AuthBaseRepository {
  // @override
  Future acceptRide(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await patch(context, url: "$kBaseUrl/emergency/accept-emergency/$data")
        .then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future arrivedRide(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await post(context, url: "$kBaseUrl/emergency/$data/responder-arrived")
        .then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future completeRide(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await patch(context, url: "$kBaseUrl/emergency/complete-emergency/$data")
        .then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
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

  // @override
  Future getResponderDashboard(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await post(context,
            url: "$kBaseUrl/dashboard/responder", data: jsonEncode(data))
        .then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
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

  // @override
  Future getReport(context) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/emergency",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  Future getGuideData(context) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/guide",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  Future getSingleGuideData(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/guide/$id",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  // @override
  Future getResponderReportById(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/emergency/responder/$data",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  Future getToken(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await post(context, url: "$kBaseUrl/agora/tokens", data: jsonEncode(data))
        .then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future updateCompleteStatus(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await patch(context, url: "$kBaseUrl/emergency/$id").then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  Future updateRetryStatus(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await patch(context, url: "$kBaseUrl/emergency/$id").then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  Future updateAcceptStatus(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await patch(context, url: "$kBaseUrl/emergency/$id").then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  Future responderArrived(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await post(context, url: "$kBaseUrl/emergency/$id/responder-arrived")
        .then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  Future getETA(
      context, String apiKey, String origin, String destination) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    final url =
        ('https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&departure_time=now&key=$apiKey');
    await get(
      context,
      url: url,
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = json.decode(response.body);
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }

  Future getQuestions(context) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/quiz",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }


  Future getQuestionsDetails(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/quiz/$id",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }
  Future answerQuestions(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await post(
      context,
      url: "$kBaseUrl/quiz/solve",
      data: jsonEncode(data)
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }


  Future getTutorial(context) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/tutorials",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }


   Future getTutorialDetails(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/tutorials/$id",
    ).then((response) {
      if (response != null) {
        var dataResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          responseMap['status'] = true;
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        } else if (response.statusCode == 401) {
          Provider.of<ProfileProvider>(context, listen: false).logout(context);
          AppNavigationHelper.setRootOldWidget(context, GetStartedPage());
        } else {
          responseMap['message'] = dataResponse['message'];
          responseMap['data'] = dataResponse;
        }
      }
    });
    return responseMap;
  }
}
