// import 'dart:convert';

// class ProfileService with AuthBaseRepository implements ProfileRepository {
//   @override
//   Future<User?> updateUser(context, User user) {
//     // TODO: implement updateUser
//     throw UnimplementedError();
//   }

//   Future getAllCountries(context) async {
//     dynamic responseMap = {"status": false, "message": "", "data": null};
//     await get(
//       context,
//       url: "$kBaseUrl/countries",
//     ).then((response) {
//       if (response != null) {
//         var dataResponse = json.decode(response.body);
//         if (response.statusCode == 200) {
//           responseMap['status'] = true;
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = json.decode(response.body);
//         } else {
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         }
//       }
//     });
//     return responseMap;
//   }

//   Future getUser(context) async {
//     dynamic responseMap = {"status": false, "message": "", "data": null};
//     await get(
//       context,
//       url: "$kBaseUrl/user",
//     ).then((response) {
//       if (response != null) {
//         var dataResponse = json.decode(response.body);
//         if (response.statusCode == 200) {
//           responseMap['status'] = true;
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = json.decode(response.body);
//         } else {
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         }
//       }
//     });
//     return responseMap;
//   }

//   Future uploadProfilePic(context, data) async {
//     dynamic responseMap = {"status": false, "message": "", "data": null};

//     await put(
//       context,
//       url: "$kBaseUrl/user",
//       data: (data)
//     ).then((response) {
//       print(response.body);

//       if (response != null) {
//         var dataResponse = json.decode(response.body);
//         if (response.statusCode == 200) {
//           responseMap['status'] = true;
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = json.decode(response.body);
//         } else {
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         }
//       }
//     });
//     return responseMap;
//   }


//   Future addTeamMember(context, data) async {
//     dynamic responseMap = {"status": false, "message": "", "data": null};

//     await post(
//       context,
//       url: "$kBaseUrl/invite-team-member",
//       data: jsonEncode(data)
//     ).then((response) {
//       // print(response.body);

//       if (response != null) {
//         var dataResponse = json.decode(response.body);
//         if (response.statusCode == 200) {
//           responseMap['status'] = true;
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = json.decode(response.body);
//         } else {
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         }
//       }
//     });
//     return responseMap;
//   }

//    Future getMembers(context) async {
//     dynamic responseMap = {"status": false, "message": "", "data": null};

//     await get(
//       context,
//       url: "$kBaseUrl/team-member",
//     ).then((response) {
//       if (response != null) {
//         var dataResponse = json.decode(response.body);
//         if (response.statusCode == 200) {
//           responseMap['status'] = true;
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = json.decode(response.body);
//         } else {
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         }
//       }
//     });
//     return responseMap;
//   }

//   Future getMyContribution(context) async {
//     dynamic responseMap = {"status": false, "message": "", "data": null};

//     await get(
//       context,
//       url: "$kBaseUrl/user/contributions",
//     ).then((response) {
//       if (response != null) {
//         var dataResponse = json.decode(response.body);
//         if (response.statusCode == 200) {
//           responseMap['status'] = true;
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = json.decode(response.body);
//         } else {
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         }
//       }
//     });
//     return responseMap;
//   }


//   Future getProfileStat(context) async {
//     dynamic responseMap = {"status": false, "message": "", "data": null};

//     await get(
//       context,
//       url: "$kBaseUrl/user/stats",
//     ).then((response) {
//       if (response != null) {
//         var dataResponse = json.decode(response.body);
//         if (response.statusCode == 200) {
//           responseMap['status'] = true;
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = json.decode(response.body);
//         } else {
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         }
//       }
//     });
//     return responseMap;
//   }
// }
