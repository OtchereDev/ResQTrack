import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/alert_dailog.dart';
import 'package:resq_track/Components/notification_popup.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Request/emergency_m.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Provider/Call/call_provider.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Provider/Report/report_provider.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Responder/Emergency/responder_emergency_details.dart';
import 'package:resq_track/Services/Firbase/request_api.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Utils/Dialogs/notifications.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Widgets/default_circle_image.dart';
import 'package:resq_track/Widgets/user_info_header.dart';

class MapWithPointers extends StatefulWidget {
  @override
  _MapWithPointersState createState() => _MapWithPointersState();
}

class _MapWithPointersState extends State<MapWithPointers> {
  GoogleMapController? _controller;

  final isShowList = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    initAgora();
    // Safely fetching current location using context.read
    context.read<LocationProvider>().getCurrentLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var pro = context.read<ResponderProvider>();
      Future.delayed(const Duration(seconds: 0), () {
        pro.getDashboardData(context);
      });
    });
  }

  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationProvider>();
    final profile = context.read<ProfileProvider>();
    var callProvider = Provider.of<CallProvider>(context);
    var responderPro = Provider.of<ResponderProvider>(context);
    // var activeEmergencyData;

    // print("========${profile.currentUserProfile?.id}");

    return Scaffold(
      body: (provider.latLong['lat'] == 0.0 && provider.latLong['lng'] == 0.0)
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection('Calls')
                  .where('receiverId',
                      isEqualTo: profile.currentUserProfile?.id ?? "")
                  .where("status", isEqualTo: "ringing")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  var callData =
                      snapshot.data!.docs.first.data() as Map<String, dynamic>;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    callProvider.listenToCallStatus(
                      callModel: CallModel.fromJson(callData),
                      context: context,
                      isReceiver: true,
                    );

                    callProvider.playContactingRing(isCaller: false);
                  });
                  if (callProvider.callStatus ==
                      "ErrorUnAnsweredVideoChatState") {
                    NotificationUtils.showToast(context,
                        message:
                            'Unexpected Error: ${callProvider.callStatus}');
                  }
                  if (callProvider.callStatus ==
                      "DownCountCallTimerFinishState") {
                    if (callProvider.remoteUid == null) {
                      callProvider.updateCallStatusToUnAnswered(
                          CallModel.fromJson(callData).id);
                    }
                  }
                  if (callProvider.callStatus == "AgoraRemoteUserJoinedEvent") {
                    callProvider.countDownTimer?.cancel();
                  }
                  if (callProvider.callStatus == "CallNoAnswerState") {
                    NotificationUtils.showToast(context,
                        message: 'No response!');
                    Navigator.pop(context);
                  }
                  if (callProvider.callStatus == "CallCancelState") {
                    NotificationUtils.showToast(context,
                        message: 'Caller cancelled the call!');

                    Navigator.pop(context);
                  }
                  if (callProvider.callStatus == "CallRejectState") {
                    NotificationUtils.showToast(context,
                        message: 'Receiver rejected the call!');
                    // Navigator.pop(context);
                  }
                  if (callProvider.callStatus == "CallEndState") {
                    NotificationUtils.showToast(context,
                        message: 'Call ended!');
                    Navigator.pop(context);
                  }

                  return ModalProgressHUD(
                    inAsyncCall: callProvider.isCalling,
                    child: WillPopScope(
                      onWillPop: () async => false,
                      child: Scaffold(
                        body: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            _remoteUid == null
                                ? !_localUserJoined
                                    ? Container(
                                        color: Colors.red,
                                        child: AgoraVideoView(
                                          controller: VideoViewController(
                                            rtcEngine: _engine,
                                            canvas: const VideoCanvas(uid: 0),
                                          ),
                                        ),
                                      )
                                    : _buildAvatarContainer(
                                        CallModel.fromJson(callData))
                                : Stack(
                                    children: [
                                      Center(
                                          child: _remoteVideo(
                                              remoteUserId: _remoteUid!,
                                              channelId:
                                                  CallModel.fromJson(callData)
                                                      .channelName!,
                                              engine: _engine)),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: SizedBox(
                                            width: 122,
                                            height: 219.0,
                                            child: AgoraVideoView(
                                              controller: VideoViewController(
                                                rtcEngine: _engine,
                                                canvas:
                                                    const VideoCanvas(uid: 0),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                            _buildUserInfoAndControls(callProvider, true,
                                CallModel.fromJson(callData), onTap: () {
                              _dispose();
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Stack(
                    children: [
                      Consumer<ReportProvider>(
                        builder: (context, report, _) {
                          if (report.isLoading) return LoadingPage();
                          if (report.emModel == null ||
                              report.emModel.isEmpty) {
                            // Handle case where no emergency data exists
                            return GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(provider.latLong['lat'],
                                    provider.latLong['lng']),
                                zoom: 17,
                              ),
                              onMapCreated: (controller) {
                                _controller = controller;
                              },
                            );
                          }
                          return GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(report.emModel[2].latitude,
                                  report.emModel[2].longitude),
                              zoom: 17,
                            ),
                            markers: _createMarkers(report.emModel),
                            onMapCreated: (controller) {
                              _controller = controller;
                            },
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: StreamBuilder<List<Map<String, dynamic>>>(
                            stream: RequestApi().getResponderActiveEmergency(
                                "CONNECTING",
                                profile.currentUserProfile?.id ?? ""),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              }

                              // print(
                              //     "===========${snapshot.data}===============");

                              // Active Emergency Data
                              final activeEmergencyData = snapshot.data!;
                              var shared_prefs_manager = SharedPrefManager();

                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                bool viewOnce =
                                    await shared_prefs_manager.getViewAlert();
                                if (activeEmergencyData.isNotEmpty &&
                                    activeEmergencyData[0]['status'] ==
                                        "CONNECTING") {
                                  if (!viewOnce) {
                                    Future.delayed(Duration(seconds: 1), () {
                                      notificationDialog(
                                          onTap: () {
                                            shared_prefs_manager.setViewNewAlert(true);
                                            AppNavigationHelper
                                                .navigateToWidget(
                                                    context,
                                                    ResponderEmergencyDetails(
                                                      emergencyData:
                                                          activeEmergencyData[
                                                              0],
                                                    ));
                                          },
                                          title: 'New Emergency Alert',
                                          message:
                                              "New Emergency with ID ${activeEmergencyData[0]['emergency_id']} and severity is ${activeEmergencyData[0]['severity']}, Please Accept Now");
                                    });
                                  }
                                }
                              });

                              return Container(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20),
                                width: double.infinity,
                                height: Utils.screenHeight(context) * 0.5,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  color: AppColors.WHITE,
                                ),
                                child: ValueListenableBuilder(
                                    valueListenable: isShowList,
                                    builder: (context, show, _) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              isShowList.value = !show;
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Active emergencies",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      isShowList.value = !show;
                                                    },
                                                    icon: Icon(show
                                                        ? Icons
                                                            .keyboard_arrow_down_rounded
                                                        : Icons
                                                            .keyboard_arrow_up_outlined))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Consumer<ReportProvider>(
                                                  builder:
                                                      (context, report, _) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${activeEmergencyData.length} active emergencies",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    AppSpaces.height16,
                                                    show
                                                        ? Column(
                                                            children: List.generate(
                                                                activeEmergencyData
                                                                    .length,
                                                                (index) {
                                                              return AcitivityTile(
                                                                activeEmergency:
                                                                    activeEmergencyData[
                                                                        index],
                                                                onTap: () {
                                                                  AppNavigationHelper
                                                                      .navigateToWidget(
                                                                          context,
                                                                          ResponderEmergencyDetails(
                                                                            emergencyData:
                                                                                activeEmergencyData[index],
                                                                          ));
                                                                },
                                                              );
                                                            }),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    AppSpaces.height20,
                                                    const Text(
                                                      "Performance Metrics",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    AppSpaces.height16,
                                                    _performanceMetricTile(
                                                        "Incident Outcome",
                                                        "Arrests",
                                                        "user_hands",
                                                        "${responderPro.homeMetrics?.numberOfArrest ?? "Loading..."}",

                                                        const Color(0xffFF1E0F)
                                                            .withOpacity(0.2),
                                                        has2: true,
                                                        value2: "${responderPro.homeMetrics?.accumulatedTurnaroundTime ?? "Loading..."}",
                                                     
                                                        onTap: () {}),
                                                    AppSpaces.height8,
                                                    _performanceMetricTile(
                                                      "Response Time",
                                                      "Arrests",
                                                      "clock1",
                                                      "${responderPro.homeMetrics?.accumulatedResponseTime ?? "Loading..."} min",
                                                      const Color(0xff0085FF)
                                                          .withOpacity(0.2),
                                                      has2: false,
                                                    ),
                                                    AppSpaces.height8,
                                                    _performanceMetricTile(
                                                      "Average On-scene Time",
                                                      "Arrests",
                                                      "pointer",
                                                      "${responderPro.homeMetrics?.accumulatedTurnaroundTime ?? "Loading..."} min",
                                                      const Color(0xff7A71D1)
                                                          .withOpacity(0.2),
                                                      has2: false,
                                                    ),
                                                    AppSpaces.height20,
                                                  ],
                                                );
                                              }),
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              );
                            }),
                      )
                    ],
                  );
                }
              }),
    );
  }

  Widget _performanceMetricTile(
      String title, String desc_1, String icon, String value1, Color color,
      {String? desc_2,
      String? value2,
      bool has2 = false,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.WHITE,
          border: Border.all(
            width: 0.8,
            color: const Color(0xffD0D5DD).withOpacity(0.6),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 15,
              child: SvgPicture.asset('assets/icons/$icon.svg'),
            ),
            const SizedBox(width: 16), // Improved spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.DEFAULT_TEXT,
                    ),
                  ),
                  const SizedBox(height: 16), // Improved spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn(desc_1, value1, has2),
                      has2
                          ? _buildStatColumn("Another Stat", "150", has2)
                          : const SizedBox
                              .shrink(), // Adjust second stat if needed
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String value, bool has2) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          has2
              ? Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.DEFAULT_TEXT,
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 8), // Improved spacing
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  Set<Marker> _createMarkers(List<EmergencyMod> emergencies) {
    return emergencies.map((emergency) {
      return Marker(
        markerId: MarkerId(emergency.name),
        position: LatLng(emergency.latitude, emergency.longitude),
        infoWindow: InfoWindow(
          title: emergency.name,
          onTap: () {
            _showShopDetails(emergency);
          },
        ),
        onTap: () {
          _showShopDetails(emergency);
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue), // Custom marker color
      );
    }).toSet();
  }

  void _showShopDetails(EmergencyMod emergency) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          height: 200, // Adjust height as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emergency.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Latitude: ${emergency.latitude}'),
              Text('Longitude: ${emergency.longitude}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AcitivityTile extends StatelessWidget {
  final dynamic activeEmergency;
  final VoidCallback? onTap;
  const AcitivityTile({
    super.key,
    this.activeEmergency,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.WHITE,
                border: Border.all(color: const Color(0xffFCF7F8)),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10)
                ]),
            child: ListTile(
              leading: CircleAvatar(
                child: SvgPicture.asset('assets/icons/ambulance2.svg'),
              ),
              title: Text(
                "${activeEmergency['type']} Emergency",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                "Home invasion with armed burglar",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: activeEmergency['status'] == "ABANDONED"
                        ? AppColors.RED
                        : AppColors.GREEN,
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "0.2 KM Away",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.WHITE),
                    ),
                    Text(
                      "ETA: 2 Mins",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.WHITE),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

// Example list of emergency models
List<EmergencyMod> shops = [
  EmergencyMod(name: 'Shop 1', latitude: 5.551176, longitude: -0.271404),
  EmergencyMod(name: 'Shop 2', latitude: 5.639878, longitude: -0.160098),
  EmergencyMod(name: 'Shop 3', latitude: 5.639792, longitude: -0.160827),
  EmergencyMod(name: 'Shop 4', latitude: 5.639515, longitude: -0.161686),
  EmergencyMod(name: 'Shop 5', latitude: 5.640287, longitude: -0.162456),
  EmergencyMod(name: 'Shop 6', latitude: 5.640308, longitude: -0.161662),
];

Widget _buildAvatarContainer(CallModel callModel) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: callModel.callerAvatar != null
            ? NetworkImage(callModel.callerAvatar!)
            : const NetworkImage('https://picsum.photos/200/300'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _buildUserInfoAndControls(
    CallProvider cubit, bool isReceiver, CallModel callModel,
    {VoidCallback? onTap}) {
  return Container(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50.0),
        isReceiver
            ? UserInfoHeader(
                avatar: callModel.receiverAvatar ?? "",
                name: callModel.receiverName!)
            : UserInfoHeader(
                avatar: callModel.callerAvatar ?? "",
                name: callModel.callerName!),
        const SizedBox(height: 30.0),
        cubit.remoteUid == null
            ? Expanded(
                child: isReceiver
                    ? Text('${callModel.callerName} is calling you..',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 39.0))
                    : const Text('Contacting..',
                        style: TextStyle(color: Colors.white, fontSize: 39.0)),
              )
            : Expanded(child: Container()),
        _buildActionButtons(cubit, true, callModel, onTap: () {}),
      ],
    ),
  );
}

Widget _buildActionButtons(
    CallProvider cubit, bool isReceiver, CallModel callModel,
    {VoidCallback? onTap}) {
  return cubit.remoteUid == null
      ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isReceiver)
              Expanded(
                child: InkWell(
                  onTap: () {
                    cubit.updateCallStatusToAccept(callModel);
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 13.0)),
                      ),
                    ),
                  ),
                ),
              ),
            if (isReceiver) const SizedBox(width: 15.0),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (isReceiver) {
                    cubit.updateCallStatusToReject(callModel.id);
                  } else {
                    cubit.updateCallStatusToCancel(callModel.id);
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
                      child: Text(isReceiver ? 'Reject' : 'Cancel',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13.0)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  cubit.switchCamera();
                },
                child: const DefaultCircleImage(
                  bgColor: Colors.white,
                  image:
                      Icon(Icons.switch_camera_outlined, color: Colors.black),
                  center: true,
                  width: 42,
                  height: 42,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onTap!();
                  cubit.performEndCall(callModel);
                },
                child: const DefaultCircleImage(
                  bgColor: Colors.red,
                  image: Icon(Icons.call_end_outlined, color: Colors.white),
                  center: true,
                  width: 42,
                  height: 42,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  cubit.toggleMuted();
                },
                child: DefaultCircleImage(
                  bgColor: Colors.white,
                  image: Icon(
                    cubit.muted ? Icons.mic_off_outlined : Icons.mic_outlined,
                    color: cubit.muted ? Colors.red : Colors.black,
                  ),
                  center: true,
                  width: 42,
                  height: 42,
                ),
              ),
            ),
          ],
        );
}

Widget _remoteVideo(
    {required int remoteUserId,
    required String channelId,
    required RtcEngine engine}) {
  return AgoraVideoView(
    controller: VideoViewController.remote(
      rtcEngine: engine,
      canvas: VideoCanvas(uid: remoteUserId),
      connection: RtcConnection(channelId: channelId),
    ),
  );
}
