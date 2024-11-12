import 'dart:convert';

import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Core/Mixins/auth_base_repository.dart';
import 'package:resq_track/Core/Repositories/Emergency/emergency_repo.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Views/GetStarted/get_started.dart';
import 'package:provider/provider.dart';

class EmergencyService with AuthBaseRepository implements EmergencyRepository {
  @override
  Future createReport(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await post(context,
            url: "$kBaseUrl/emergency/create", data: jsonEncode(data))
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

  @override
  Future uploadEmergencyPhoto(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};

    await post(context,
            url: "$kBaseUrl/emergency/upload-photos", data: jsonEncode(data))
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

  @override
  Future getReport(context) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/emergency",
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

  @override
  Future getReportById(context, data) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await get(
      context,
      url: "$kBaseUrl/emergency/$data",
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
    await patch(context, url: "$kBaseUrl/emergency/$id")
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

   Future updateRetryStatus(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await patch(context, url: "$kBaseUrl/emergency/$id")
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

   Future updateAcceptStatus(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await patch(context, url: "$kBaseUrl/emergency/$id")
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


   Future getDashboardData(context, id) async {
    dynamic responseMap = {"status": false, "message": "", "data": null};
    await post(context, url: "$kBaseUrl/dashboard/responder", data: jsonEncode(id))
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


}
