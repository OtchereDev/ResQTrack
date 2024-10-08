
// import 'dart:convert';

// import 'package:fund_peck/Core/Mixins/auth_base_repository.dart';
// import 'package:fund_peck/Core/app_constants.dart';

// class UtilServices with AuthBaseRepository {

//   Future<dynamic> fetchPredictions(context,String input) async {
//     // print(input);

//     final apiUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
//         '?input=$input'
//         '&key=$kGoogleApiKey';
//         // '&session_token=$sessionToken';

//         var prediction;

//     final response = await get(context,url:apiUrl);
//     final data = json.decode(response.body);


//     if (data['predictions'] != null) {
//     prediction = List<String>.from(data['predictions'].map((prediction) => prediction['description']));
//     }
//     return prediction;
//   }


  // Future<dynamic> createPaypalPayment(context, data) async {
  //   dynamic responseMap = {"status": false, "message": "", "data": null};
  //   await post(
  //     context,
  //     url: "https://q85wmohwmg.execute-api.eu-west-2.amazonaws.com/v1/payments-ticket",
  //     data: jsonEncode(data),
  //     // useContentType: true
  //   ).then((response) {
  //     print(response?.body);
  //     if (response != null) {
  //       var dataResponse = json.decode(response.body);
  //       if (response.statusCode == 200) {
  //         responseMap['status'] = true;
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = dataResponse;
  //       } else {
  //         responseMap['message'] = dataResponse['message'];
  //         responseMap['data'] = dataResponse;
  //       }
  //     }
  //   });
  //   return responseMap;
  // }

// }