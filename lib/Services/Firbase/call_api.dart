import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Services/Remote/Emergency/emergency_service.dart';

class CallApi {
  StreamSubscription<dynamic>
      listenToInComingCall(String userId) {
    return FirebaseFirestore.instance
        .collection(callsCollection)
        .where('receiverId', isEqualTo: userId) //CacheHelper.getString(key: 'uId'))
        .snapshots()
        .listen((event) {});
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listenToCallStatus(
      {required String callId}) {
    return FirebaseFirestore.instance
        .collection(callsCollection)
        .doc(callId)
        .snapshots()
        .listen((event) {});
  }

  Future<void> postCallToFirestore({required CallModel callModel}) {
    return FirebaseFirestore.instance
        .collection(callsCollection)
        .doc(callModel.id)
        .set(callModel.toMap());
  }

  Future<void> updateUserBusyStatusFirestore(
      {required CallModel callModel, required bool busy}) {
    Map<String, dynamic> busyMap = {'busy': busy};
    return FirebaseFirestore.instance
        .collection(userCollection)
        .doc(callModel.callerId)
        .update(busyMap)
        .then((value) {
      FirebaseFirestore.instance
          .collection(userCollection)
          .doc(callModel.receiverId)
          .update(busyMap);
    });
  }

  //Sender
  Future<String?> generateCallToken(context) async {
    final _servcer = EmergencyService();
    String? token;

    Map<String, dynamic> body = {"channelName": agoraTestChannelName, "role":"publisher"};
    await _servcer.getToken(context, body).then((val) {
      print("------Agora Token-----------$val-----------------");
      if (val['status'] == true) {
        token = val['data']['tokens']['rtc'];
      }
    });
    return token;
  }

  Future<void> updateCallStatus(
      {required String callId, required String status}) {
    return FirebaseFirestore.instance
        .collection(callsCollection)
        .doc(callId)
        .update({'status': status});
  }

  Future<void> endCurrentCall({required String callId}) {
    return FirebaseFirestore.instance
        .collection(callsCollection)
        .doc(callId)
        .update({'current': false});
  }
}
