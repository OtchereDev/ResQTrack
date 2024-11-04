// import 'dart:async';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:resq_track/Core/app_constants.dart';
// import 'package:resq_track/Model/Response/call_model.dart';
// import 'package:resq_track/Provider/Call/call_provider.dart';
// import 'package:resq_track/Provider/Profile/profile_provider.dart';
// import 'package:resq_track/Utils/Dialogs/notifications.dart';
// import 'package:resq_track/Widgets/default_circle_image.dart';
// import 'package:resq_track/Widgets/user_info_header.dart';

// class ResponderCallPage extends StatefulWidget {
//   final CallModel callModel;
//   final bool isReceiver;
//   const ResponderCallPage(
//       {super.key, required this.callModel, required this.isReceiver});

//   @override
//   State<ResponderCallPage> createState() => _ResponderCallPageState();
// }

// class _ResponderCallPageState extends State<ResponderCallPage> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         initAgora();
//         rePermission();
//         Provider.of<ProfileProvider>(context, listen: false).getUser(context);
//       }
//     });
//   }

//   Future<void> rePermission() async {
//     await [Permission.microphone, Permission.camera].request();
//   }

//   Future<void> initAgora() async {
//     // retrieve permissions
//     await [Permission.microphone, Permission.camera].request();

//     //create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: agoraAppId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));

//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );

//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(
//         "-------Remote ID------$_remoteUid----------------------------------");

//     return Scaffold(
//       body: Consumer<CallProvider>(builder: (context, state, _) {
//         return Consumer<ProfileProvider>(builder: (context, profile, _) {
//           return StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('Calls')
//                   .where('receiverId',
//                       isEqualTo: profile.currentUserProfile?.id ?? "")
//                   .where("status", isEqualTo: "ringing")
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
          
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   var callProvider =
//                       Provider.of<CallProvider>(context, listen: false);
          
//                   callProvider.listenToCallStatus(
//                     callModel: (widget.callModel),
//                     context: context,
//                     isReceiver: true,
//                   );
          
//                   callProvider.playContactingRing(isCaller: false);
//                 });
//                 if (state.callStatus == "ErrorUnAnsweredVideoChatState") {
//                   NotificationUtils.showToast(context,
//                       message: 'Unexpected Error: ${state.callStatus}');
//                 }
//                 if (state.callStatus == "DownCountCallTimerFinishState") {
//                   if (state.remoteUid == null) {
//                     state.updateCallStatusToUnAnswered(widget.callModel.id);
//                   }
//                 }
//                 if (state.callStatus == "AgoraRemoteUserJoinedEvent") {
//                   state.countDownTimer?.cancel();
//                 }
//                 if (state.callStatus == "CallNoAnswerState") {
//                   NotificationUtils.showToast(context,
//                       message: 'No response!');
//                   Navigator.pop(context);
//                 }
//                 if (state.callStatus == "CallCancelState") {
//                   NotificationUtils.showToast(context,
//                       message: 'Caller cancelled the call!');
          
//                   Navigator.pop(context);
//                 }
//                 if (state.callStatus == "CallRejectState") {
//                   NotificationUtils.showToast(context,
//                       message: 'Receiver rejected the call!');
//                   Navigator.pop(context);
//                 }
//                 if (state.callStatus == "CallEndState") {
//                   NotificationUtils.showToast(context,
//                       message: 'Call ended!');
//                   Navigator.pop(context);
//                 }
          
//                 return ModalProgressHUD(
//                   inAsyncCall: false,
//                   child: WillPopScope(
//                     onWillPop: () async => false,
//                     child: Scaffold(
//                       body: Stack(
//                         alignment: AlignmentDirectional.center,
//                         children: [
//                           _remoteUid == null
//                               ? !widget.isReceiver
//                                   ? Container(
//                                       color: Colors.red,
//                                       child: _localUserJoined
//                                           ? AgoraVideoView(
//                                               controller:
//                                                   VideoViewController(
//                                                 rtcEngine: _engine,
//                                                 canvas: const VideoCanvas(
//                                                     uid: 0),
//                                               ),
//                                             )
//                                           : const Center(
//                                               child:
//                                                   CircularProgressIndicator(),
//                                             ),
//                                     )
//                                   : _buildAvatarContainer(widget.callModel)
//                               : Stack(
//                                   children: [
//                                     Center(
//                                       child: _remoteVideo(
//                                           remoteUserId: _remoteUid!,
//                                           channelId:
//                                               widget.callModel.channelName!,
//                                           engine: _engine),
//                                     ),
//                                     Align(
//                                       alignment: Alignment.bottomRight,
//                                       child: SizedBox(
//                                         width: 122,
//                                         height: 219.0,
//                                         child: _localUserJoined
//                                             ? AgoraVideoView(
//                                                 controller:
//                                                     VideoViewController(
//                                                   rtcEngine: _engine,
//                                                   canvas: const VideoCanvas(
//                                                       uid: 0),
//                                                 ),
//                                               )
//                                             : const Center(
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                           _buildUserInfoAndControls(
//                               state, widget.isReceiver, widget.callModel),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               });
//         });
//       }),
//     );
//   }
// }

// Widget _buildAvatarContainer(CallModel callModel) {
//   return Container(
//     decoration: BoxDecoration(
//       image: DecorationImage(
//         image: callModel.callerAvatar != null
//             ? NetworkImage(callModel.callerAvatar!)
//             : const NetworkImage('https://picsum.photos/200/300'),
//         fit: BoxFit.cover,
//       ),
//     ),
//   );
// }

// Widget _buildUserInfoAndControls(
//     CallProvider cubit, bool isReceiver, CallModel callModel) {
//   return Container(
//     padding: const EdgeInsets.all(15.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const SizedBox(height: 50.0),
//         isReceiver
//             ? UserInfoHeader(
//                 avatar: callModel.receiverAvatar ?? "",
//                 name: callModel.receiverName!)
//             : UserInfoHeader(
//                 avatar: callModel.callerAvatar ?? "",
//                 name: callModel.callerName!),
//         const SizedBox(height: 30.0),
//         cubit.remoteUid == null
//             ? Expanded(
//                 child: isReceiver
//                     ? Text('${callModel.callerName} is calling you..',
//                         style: const TextStyle(
//                             color: Colors.white, fontSize: 39.0))
//                     : const Text('Contacting..',
//                         style: TextStyle(color: Colors.white, fontSize: 39.0)),
//               )
//             : Expanded(child: Container()),
//         _buildActionButtons(cubit, true, callModel),
//       ],
//     ),
//   );
// }

// Widget _buildActionButtons(
//     CallProvider cubit, bool isReceiver, CallModel callModel) {
//   return cubit.remoteUid == null
//       ? Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (isReceiver)
//               Expanded(
//                 child: InkWell(
//                   onTap: () {
//                     cubit.updateCallStatusToAccept(callModel);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15.0),
//                       color: Colors.green,
//                     ),
//                     child: const Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 30.0, vertical: 8.0),
//                         child: Text('Accept',
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 13.0)),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             if (isReceiver) const SizedBox(width: 15.0),
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   if (isReceiver) {
//                     cubit.updateCallStatusToReject(callModel.id);
//                   } else {
//                     cubit.updateCallStatusToCancel(callModel.id);
//                   }
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15.0),
//                     color: Colors.red,
//                   ),
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30.0, vertical: 8.0),
//                       child: Text(isReceiver ? 'Reject' : 'Cancel',
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 13.0)),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         )
//       : Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   cubit.switchCamera();
//                 },
//                 child: const DefaultCircleImage(
//                   bgColor: Colors.white,
//                   image:
//                       Icon(Icons.switch_camera_outlined, color: Colors.black),
//                   center: true,
//                   width: 42,
//                   height: 42,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   cubit.performEndCall(callModel);
//                 },
//                 child: const DefaultCircleImage(
//                   bgColor: Colors.red,
//                   image: Icon(Icons.call_end_outlined, color: Colors.white),
//                   center: true,
//                   width: 42,
//                   height: 42,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   cubit.toggleMuted();
//                 },
//                 child: DefaultCircleImage(
//                   bgColor: Colors.white,
//                   image: Icon(
//                     cubit.muted ? Icons.mic_off_outlined : Icons.mic_outlined,
//                     color: cubit.muted ? Colors.red : Colors.black,
//                   ),
//                   center: true,
//                   width: 42,
//                   height: 42,
//                 ),
//               ),
//             ),
//           ],
//         );
// }

// Widget _remoteVideo(
//     {required int remoteUserId,
//     required String channelId,
//     required RtcEngine engine}) {
//   return AgoraVideoView(
//     controller: VideoViewController.remote(
//       rtcEngine: engine,
//       canvas: VideoCanvas(uid: remoteUserId),
//       connection: RtcConnection(channelId: channelId),
//     ),
//   );
// }
