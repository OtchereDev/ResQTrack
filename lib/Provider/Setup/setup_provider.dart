import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Services/Firbase/call_api.dart';
import 'package:resq_track/Services/Firbase/fcm_request.dart';
import 'package:resq_track/Services/Firbase/home_api.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Services/fcm/notification_service.dart'; // Change from Bloc to Provider

// Replace Cubit with ChangeNotifier
class SetupProvider extends ChangeNotifier {
  final NotificationService firebaseNotifications = NotificationService();
  final HomeApi _homeApi = HomeApi();
  final CallApi _callApi = CallApi();

  // List<UserModel> users = [];
  // List<CallModel> calls = [];
  bool fireCallLoading = false;
  CallStatus? currentCallStatus;

  void updateFcmToken() {
    FirebaseMessaging.instance.getToken().then((token) async {
      var user = await SharedPrefManager().getUser();
      // UserFcmTokenModel tokenModel = UserFcmTokenModel(token: token!, uId: uId);
      FirebaseFirestore.instance
          .collection(tokensCollection)
          .doc(user?.id ?? "")
          .set({"token": token, "userId": user?.id}).then((value) {
        debugPrint('User Fcm Token Updated $token');
      }).catchError((onError) {
        debugPrint(onError.toString());
      });
    });
  }

  // Fetch users in real time
  void getUsersRealTime() {
    // _homeApi.getUsersRealTime().onData((data) {
    //   if (data.size != 0) {
    //     users = []; // For real-time update the list
    //     for (var element in data.docs) {
    //       if (!users.any((e) => e.id == element.id)) {
    //         users.add(UserModel.fromJsonMap(map: element.data(), uId: element.id));
    //       }
    //     }
    //     notifyListeners(); // Notify state change
    //   } else {
    //     debugPrint('No users found');
    //   }
    // });
  }

  // Fetch call history in real time
  void getCallHistoryRealTime() {
    _homeApi.getCallHistoryRealTime().onData((data) {
      if (data.size != 0) {
        // calls = []; // For real-time update the list
        for (var element in data.docs) {
          print("----------$element--------");
          // if (element.data()['callerId'] == CacheHelper.getString(key: 'uId') ||
          //     element.data()['receiverId'] == CacheHelper.getString(key: 'uId')) {
          //   var call = CallModel.fromJson(element.data());
          //   if (call.callerId == CacheHelper.getString(key: 'uId')) {
          //     call.otherUser = UserModel(name: call.receiverName!, avatar: call.receiverAvatar!);
          //   } else {
          //     call.otherUser = UserModel(name: call.callerName!, avatar: call.callerAvatar!);
          //   }
          //   calls.add(call);
          // }
        }
        notifyListeners(); // Notify state change
      } else {
        debugPrint('No Call History');
      }
    });
  }

  // Fire a video call
  Future<void> fireVideoCall(context, {required CallModel callModel}) async {
    fireCallLoading = true;
    notifyListeners(); // Notify loading state
    await _callApi.generateCallToken(context).then((value) {
      callModel.token = agoraTestToken;
      callModel.channelName = agoraTestChannelName;
      postCallToFirestore(context,callModel: callModel);
    }).catchError((onError) {
      callModel.token = agoraTestToken;
      callModel.channelName = agoraTestChannelName;
      fireCallLoading = false;
      debugPrint(onError.toString());
      postCallToFirestore(context,
          callModel: callModel); // For testing, use default tokens
    });
  }

  // Post call details to Firestore
  void postCallToFirestore(context,{required CallModel callModel}) {
    _callApi.postCallToFirestore(callModel: callModel).then((value) {
      _callApi
          .updateUserBusyStatusFirestore(callModel: callModel, busy: true)
          .then((value) {
        fireCallLoading = false;
        sendNotificationForIncomingCall(context,callModel: callModel);
        notifyListeners(); // Notify state change
      }).catchError((onError) {
        fireCallLoading = false;
        notifyListeners(); // Notify state change
      });
    }).catchError((onError) {
      fireCallLoading = false;
      notifyListeners(); // Notify state change
    });
  }

  // Send notification for incoming call
  void sendNotificationForIncomingCall(context,
      {required CallModel callModel}) {
    FirebaseFirestore.instance
        .collection(tokensCollection)
        .doc(callModel.receiverId)
        .get()
        .then((value) async {
      if (value.exists) {
        sendFCMNotification(context, value.data()!['token'], callModel.toMap());
      }
    }).catchError((onError) {
      fireCallLoading = false;
      notifyListeners(); // Notify state change
    });
  }

  // Listen to incoming calls
  void listenToInComingCalls(String id) {
    _callApi.listenToInComingCall(id).onData((data) {
      if (data.size != 0) {
        for (var element in data.docs) {
          if (element.data()['current'] == true) {
            String status = element.data()['status'];
            if (status == CallStatus.ringing.name) {
              currentCallStatus = CallStatus.ringing;
              notifyListeners(); // Notify state change
            }
          }
        }
      }
    });
  }
}
