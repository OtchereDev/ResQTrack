import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Provider/Call/call_provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Utils/Dialogs/notifications.dart';
import 'package:resq_track/Widgets/default_circle_image.dart';
import 'package:resq_track/Widgets/user_info_header.dart';

class ResponderHomePage extends StatefulWidget {
  const ResponderHomePage({super.key});

  @override
  State<ResponderHomePage> createState() => _ResponderHomePageState();
}

class _ResponderHomePageState extends State<ResponderHomePage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _muted = false; // Track if the mic is muted
  bool _videoOff = false; // Track if the video is off
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: agoraTestToken,
      channelId: agoraTestChannelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Toggle mute
  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  // Toggle video
  void _onToggleVideo() {
    setState(() {
      _videoOff = !_videoOff;
    });
    _engine.muteLocalVideoStream(_videoOff);
  }

  // Switch camera
  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  // End call
  void _onCallEnd(BuildContext context,callModel ) {

    _dispose();
    Navigator.pop(context);
    Provider.of<CallProvider>(context).performEndCall(callModel);
  }

  @override
  Widget build(BuildContext context) {
      var callData;
    print(
        "------Responder-Remote ID------$_remoteUid----------------------------------");

    return Scaffold(
      body: Consumer<CallProvider>(builder: (context, state, _) {
        return Consumer<ProfileProvider>(builder: (context, profile, _) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Calls')
                .where('receiverId',
                    isEqualTo: profile.currentUserProfile?.id ?? "")
                .where("status", isEqualTo: "ringing")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                 callData =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  var callProvider =
                      Provider.of<CallProvider>(context, listen: false);

                  callProvider.listenToCallStatus(
                    callModel: CallModel.fromJson(callData),
                    context: context,
                    isReceiver: true,
                  );

                  callProvider.playContactingRing(isCaller: false);
                });
                if (state.callStatus == "ErrorUnAnsweredVideoChatState") {
                  NotificationUtils.showToast(context,
                      message: 'Unexpected Error: ${state.callStatus}');
                }
                if (state.callStatus == "DownCountCallTimerFinishState") {
                  if (state.remoteUid == null) {
                    state.updateCallStatusToUnAnswered(
                        CallModel.fromJson(callData).id);
                  }
                }
                if (state.callStatus == "AgoraRemoteUserJoinedEvent") {
                  state.countDownTimer?.cancel();
                }
                if (state.callStatus == "CallNoAnswerState") {
                  NotificationUtils.showToast(context, message: 'No response!');
                  Navigator.pop(context);
                }
                if (state.callStatus == "CallCancelState") {
                  NotificationUtils.showToast(context,
                      message: 'Caller cancelled the call!');

                  Navigator.pop(context);
                }
                if (state.callStatus == "CallRejectState") {
                  NotificationUtils.showToast(context,
                      message: 'Receiver rejected the call!');
                  // Navigator.pop(context);
                }
                if (state.callStatus == "CallEndState") {
                  NotificationUtils.showToast(context, message: 'Call ended!');
                  Navigator.pop(context);
                }

                return Stack(
                  children: [
                    Center(
                      child: _remoteVideo(),
                    ),
                    _toolbar(CallModel.fromJson(callData)),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 100,
                        height: 150,
                        child: Center(
                          child: _localUserJoined
                              ? AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: _engine,
                                    canvas: const VideoCanvas(uid: 0),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text("No Incoming Calls"));
              }
            },
          );
        });
      }),
    );
  }

  // Toolbar for video controls
  Widget _toolbar(CallModel callModel) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RawMaterialButton(
              onPressed: _onToggleMute,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: _muted ? Colors.redAccent : Colors.blueAccent,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                _muted ? Icons.mic_off : Icons.mic,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: _onToggleVideo,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: _videoOff ? Colors.redAccent : Colors.blueAccent,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                _videoOff ? Icons.videocam_off : Icons.videocam,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: _onSwitchCamera,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.blueAccent,
              padding: const EdgeInsets.all(12.0),
              child: const Icon(
                Icons.switch_camera,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: () => _onCallEnd(context, callModel),
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(15.0),
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: agoraTestChannelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
