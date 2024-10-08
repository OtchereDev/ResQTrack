
// import 'dart:convert';

// class PaymentServices with AuthBaseRepository {
//     Future<dynamic> donateToCampaign(context, data) async {
//     dynamic responseMap = {"status": false, "message": "", "data": null};
//     await post(
//       context,
//       url: "$kBaseUrl/contribute-to-campaign",
//       data: jsonEncode(data),
//     ).then((response) {
//       // print(response?.body);
//       if (response != null) {
//         var dataResponse = json.decode(response.body);
//         if (response.statusCode == 200) {
//           responseMap['status'] = true;
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         } else {
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         }
//       }
//     });
//     return responseMap;
//   }


//    Future<dynamic> getPaymentServices(context) async {
//     dynamic responseMap = {"status": false, "message": "", "data": null};
//     await get(
//       context,
//       url: "$kBaseUrl/payment-services",
//     ).then((response) {
//       if (response != null) {
//         var dataResponse = json.decode(response.body);
//         if (response.statusCode == 200) {
//           responseMap['status'] = true;
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         } else {
//           responseMap['message'] = dataResponse['message'];
//           responseMap['data'] = dataResponse;
//         }
//       }
//     });
//     return responseMap;
//   }
// }