import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Provider/Call/call_provider.dart';

class AgoraMyApp extends StatefulWidget {
  final CallModel callModel;
  const AgoraMyApp({Key? key, required this.callModel}) : super(key: key);

  @override
  State<AgoraMyApp> createState() => _AgoraMyAppState();
}

class _AgoraMyAppState extends State<AgoraMyApp> {
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

    // create the engine
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
// 67056884a5a217b66542510f
  // End call
  void _onCallEnd(BuildContext context) {
      var callProvider = Provider.of<CallProvider>(context, listen: false);
    _engine.leaveChannel();
    _engine.release();
    callProvider.performEndCall(widget.callModel);
    _dispose();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          _toolbar(),
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
      ),
    );
  }

  // Toolbar for video controls
  Widget _toolbar() {
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
              onPressed: () => _onCallEnd(context),
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