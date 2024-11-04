import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:quiver/async.dart';
import 'package:resq_track/Services/Firbase/call_api.dart';

class CallProvider with ChangeNotifier {
  int? remoteUid;
  late RtcEngine engine;
  bool muted = false;
  bool isCalling = false;
  String _callState = CallStatus.none.name;
  String get callStatus => _callState;
  int current = 0;
  CountdownTimer? countDownTimer;

  final CallApi _callApi = CallApi();

  Future<void> initAgoraAndJoinChannel({
    required String channelToken,
    required String channelName,
    required bool isCaller,
  }) async {
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(appId: agoraAppId));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          remoteUid = uid;
          _callState = "AgoraRemoteUserJoinedEvent";
          notifyListeners(); // Notify listeners about remote user
        },
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          remoteUid = null;
          _callState = "AgoraUserLeftEvent";
          notifyListeners(); // Notify listeners about user leaving
        },
        onError: (err, msg) {
          _callState = "AgoraUserError";
          print("Error: ${err.toString()} - Message: $msg");
          notifyListeners(); // Notify listeners about the error
        },
      ),
    );
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    // await engine.startPreview();

    // await engine.joinChannel(
    //   token: channelToken,
    //   channelId: channelName,
    //   uid: 0,
    //   options: const ChannelMediaOptions(),
    // );

    _callState = isCaller
        ? "AgoraInitForSenderSuccessState"
        : "AgoraInitForReceiverSuccessState";
    if (isCaller) {
      playContactingRing(isCaller: true);
    }

    notifyListeners();
  }

  Future<void> playContactingRing({required bool isCaller}) async {
    if (isCaller) {
      startCountdownCallTimer();
    }
  }

  void startCountdownCallTimer() {
    countDownTimer = CountdownTimer(
      const Duration(seconds: callDurationInSec),
      const Duration(seconds: 1),
    );
    var sub = countDownTimer!.listen(null);
    sub.onData((duration) {
      current = callDurationInSec - duration.elapsed.inSeconds;
      notifyListeners();
    });

    sub.onDone(() {
      sub.cancel();
      _callState = "DownCountCallTimerFinishState";
      notifyListeners();
    });
  }

  Future<void> toggleMuted() async {
    muted = !muted;
    await engine.muteLocalAudioStream(muted);
    _callState = "AgoraToggleMutedState";
    notifyListeners();
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
    _callState = "AgoraSwitchCameraState";
    notifyListeners();
  }

  Future<void> updateCallStatusToUnAnswered(String callId) async {
    await _callApi
        .updateCallStatus(callId: callId, status: 'unAnswer')
        .then((val) {
      _callState = "SuccessUnAnsweredVideoChatState";
      notifyListeners();
    }).onError((val, stackTrace) {
      _callState = "ErrorUnAnsweredVideoChatState";
      notifyListeners();
    });
  }

  void leaveChannel() {
    engine.leaveChannel();
  }

  Future<void> updateCallStatusToCancel(String callId) async {
    await _callApi.updateCallStatus(callId: callId, status: 'cancel');
  }

  Future<void> updateCallStatusToReject(String callId) async {
    await _callApi.updateCallStatus(callId: callId, status: 'reject');
  }

  Future<void> updateCallStatusToAccept(CallModel callModel) async {
    await _callApi.updateCallStatus(callId: callModel.id, status: 'accept');
    initAgoraAndJoinChannel(
      channelToken: callModel.token!,
      channelName: callModel.channelName ?? 'EmergencyCall',
      isCaller: false,
    );
  }

  Future<void> updateUserBusyStatusFirestore(
      {required CallModel callModel}) async {
    await _callApi.updateUserBusyStatusFirestore(
        callModel: callModel, busy: false);
  }

  Future<void> updateCallStatusToEnd(String callId) async {
    await _callApi.updateCallStatus(callId: callId, status: 'end');
  }

  Future<void> endCurrentCall({required String callId}) async {
    await _callApi.endCurrentCall(callId: callId);
  }

  Future<void> performEndCall(CallModel callModel) async {
    await endCurrentCall(callId: callModel.id);
    await updateUserBusyStatusFirestore(callModel: callModel);
  }

  StreamSubscription? callStatusStreamSubscription;

  void listenToCallStatus({
    required CallModel callModel,
    required BuildContext context,
    required bool isReceiver,
  }) {
    callStatusStreamSubscription =
        _callApi.listenToCallStatus(callId: callModel.id);
    callStatusStreamSubscription!.onData((data) {
      if (data.exists) {
        String status = data.data()!['status'];
        switch (status) {
          case 'accept':
            _callState = "CallAcceptState";
            callStatusStreamSubscription!.cancel();
            notifyListeners();
            break;
          case 'reject':
            _callState = "CallRejectState";
            callStatusStreamSubscription!.cancel();
            notifyListeners();
            break;
          case 'unAnswer':
            _callState = "CallNoAnswerState";
            callStatusStreamSubscription!.cancel();
            notifyListeners();
            break;
          case 'cancel':
            _callState = "CallCancelState";
            callStatusStreamSubscription!.cancel();
            notifyListeners();
            break;
          case 'end':
            _callState = "CallEndState";
            callStatusStreamSubscription!.cancel();
            notifyListeners();
            break;
        }
      }
    });
  }

  // Consider implementing a dispose method to clean up subscriptions
  void dispose() {
    callStatusStreamSubscription?.cancel();
    super.dispose();
  }
}
