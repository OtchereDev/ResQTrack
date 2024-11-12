import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Provider/Call/call_provider.dart';
import 'package:resq_track/Utils/Dialogs/notifications.dart';
import 'package:resq_track/Widgets/default_circle_image.dart';
import 'package:resq_track/Widgets/user_info_header.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CallScreen extends StatefulWidget {
  final bool isReceiver;
  final CallModel callModel;

  const CallScreen({Key? key, required this.isReceiver, required this.callModel})
      : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _localUserJoined = false;

  @override
  void initState() {
    super.initState();
    var callProvider = Provider.of<CallProvider>(context, listen: false);
    rePermission();
    initializeAgora();

    callProvider.listenToCallStatus(
      callModel: widget.callModel,
      context: context,
      isReceiver: widget.isReceiver,
    );

    if (!widget.isReceiver) {
      callProvider.initAgoraAndJoinChannel(
        channelToken: widget.callModel.token!,
        channelName: widget.callModel.channelName!,
        isCaller: true,
      );
    } else {
      callProvider.playContactingRing(isCaller: false);
    }
  }

  Future<void> initializeAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: agoraAppId));
   await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo(); // Enable video stream
    await _engine.startPreview(); // Start preview for local video feed

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    var callProvider = Provider.of<CallProvider>(context, listen: false);
    _engine.leaveChannel();
    _engine.release();
    callProvider.performEndCall(widget.callModel);
    super.dispose();
  }

  Future<void> rePermission() async {
    await [Permission.microphone, Permission.camera].request(); // Request permissions
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallProvider>(
      builder: (BuildContext context, state, _) {
        _handleCallStatus(state);

        return ModalProgressHUD(
          inAsyncCall: false,
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              body: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  _remoteUid == null
                      ? !widget.isReceiver
                          ? Container(
                              color: Colors.red,
                              child: _localUserJoined
                                  ? AgoraVideoView(
                                      controller: VideoViewController(
                                        rtcEngine: _engine,
                                        canvas: const VideoCanvas(uid: 0),
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            )
                          : _buildAvatarContainer()
                      : Stack(
                          children: [
                            Center(
                              child: _remoteVideo(
                                remoteUserId: _remoteUid!,
                                channelId: widget.callModel.channelName!,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: 122,
                                height: 219.0,
                                child: _localUserJoined
                                    ? AgoraVideoView(
                                        controller: VideoViewController(
                                          rtcEngine: _engine,
                                          canvas: const VideoCanvas(uid: 0),
                                        ),
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            ),
                          ],
                        ),
                  _buildUserInfoAndControls(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleCallStatus(CallProvider state) {
    switch (state.callStatus) {
      case "ErrorUnAnsweredVideoChatState":
        NotificationUtils.showToast(context,
            message: 'Unexpected Error: ${state.callStatus}');
        break;
      case "DownCountCallTimerFinishState":
        if (state.remoteUid == null) {
          state.updateCallStatusToUnAnswered(widget.callModel.id);
        }
        break;
      case "AgoraRemoteUserJoinedEvent":
        if (!widget.isReceiver) {
          state.countDownTimer?.cancel();
        }
        break;
      case "AgoraUserError":
        Navigator.pop(context);
        break;
      case "CallNoAnswerState":
        if (!widget.isReceiver) {
          NotificationUtils.showToast(context, message: 'No response!');
        }
        Navigator.pop(context);
        break;
      case "CallCancelState":
        if (widget.isReceiver) {
          NotificationUtils.showToast(context,
              message: 'Caller cancelled the call!');
        }
        Navigator.pop(context);
        break;
      case "CallRejectState":
        if (!widget.isReceiver) {
          NotificationUtils.showToast(context,
              message: 'Receiver rejected the call!');
        }
        Navigator.pop(context);
        break;
      case "CallEndState":
        NotificationUtils.showToast(context, message: 'Call ended!');
        Navigator.pop(context);
        break;
    }
  }

  Widget _buildAvatarContainer() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: widget.callModel.callerAvatar!.isNotEmpty
              ? NetworkImage(widget.callModel.callerAvatar!)
              : const NetworkImage('https://picsum.photos/200/300'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUserInfoAndControls(CallProvider cubit) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50.0),
          !widget.isReceiver
              ? UserInfoHeader(
                  avatar: widget.callModel.receiverAvatar ?? "",
                  name: widget.callModel.receiverName!)
              : UserInfoHeader(
                  avatar: widget.callModel.callerAvatar ?? "",
                  name: widget.callModel.callerName!),
          const SizedBox(height: 30.0),
          cubit.remoteUid == null
              ? Expanded(
                  child: widget.isReceiver
                      ? Text('${widget.callModel.callerName} is calling you..',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 39.0))
                      : const Text('Contacting..',
                          style:
                              TextStyle(color: Colors.white, fontSize: 39.0)),
                )
              : Expanded(child: Container()),
          _buildActionButtons(cubit),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CallProvider cubit) {
    return cubit.remoteUid == null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isReceiver)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      cubit.updateCallStatusToAccept(widget.callModel);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green,
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          child: Text('Accept',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.isReceiver) const SizedBox(width: 15.0),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (widget.isReceiver) {
                      cubit.updateCallStatusToReject(widget.callModel.id);
                    } else {
                      cubit.updateCallStatusToCancel(widget.callModel.id);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        child: Text(widget.isReceiver ? 'Reject' : 'Cancel',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : IconButton(
            onPressed: () {
              cubit.performEndCall(widget.callModel);
            },
            icon: const Icon(Icons.call_end),
            iconSize: 40.0,
            color: Colors.red,
          );
  }

  Widget _remoteVideo({required int remoteUserId, required String channelId}) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: remoteUserId),
        connection: RtcConnection(channelId: channelId),
      ),
    );
  }
}