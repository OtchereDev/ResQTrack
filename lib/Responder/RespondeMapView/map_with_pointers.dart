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
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Responder/Emergency/responder_emergency_details.dart';
import 'package:resq_track/Responder/Emergency/responder_to_emergency.dart';
import 'package:resq_track/Services/Firbase/request_api.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Views/MapViews/map_view.dart';
import 'package:resq_track/Widgets/default_circle_image.dart';
import 'package:resq_track/Widgets/user_info_header.dart';

class MapWithPointers extends StatefulWidget {
  @override
  _MapWithPointersState createState() => _MapWithPointersState();
}

class _MapWithPointersState extends State<MapWithPointers> {
  final ValueNotifier<bool> isShowList = ValueNotifier(true);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().getCurrentLocation();
      context.read<ResponderProvider>().getDashboardData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationProvider>();
    final profile = context.read<ProfileProvider>();
    // final responderPro = context.watch<ResponderProvider>();

    return Scaffold(
      body: (provider.latLong['lat'] == 0.0 && provider.latLong['lng'] == 0.0)
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                MapScreen(height: Utils.screenHeight(context) * 0.5),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Consumer<RequestApi>(
                    builder: (context, api, _) {
                      return StreamBuilder<List<Map<String, dynamic>>>(
                        stream: api.getResponderActiveEmergency("CONNECTING", profile.currentUserProfile?.id ?? ""),
                        builder: (context, snapshot) {
                          // if (snapshot.connectionState == ConnectionState.waiting) return SizedBox.shrink();
                          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

                          final activeEmergencyData = snapshot.data ?? [];

                          // Show dialog once if an emergency is found
                          _showEmergencyAlertDialogOnce(activeEmergencyData);

                          return _buildBottomContainer(context, activeEmergencyData);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // Separate function to build the bottom container
  Widget _buildBottomContainer(BuildContext context, List<Map<String, dynamic>> activeEmergencyData) {
    final responderPro = context.read<ResponderProvider>();
    final profile = context.read<ProfileProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: Utils.screenHeight(context) * 0.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: AppColors.WHITE,
      ),
      child: ValueListenableBuilder(
        valueListenable: isShowList,
        builder: (context, show, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActiveEmergenciesHeader(show),
        Text("${activeEmergencyData.length} active emergencies", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),

             Expanded(
               child: SingleChildScrollView(
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     if (show) _buildEmergencyList(activeEmergencyData),
                  AppSpaces.height20,
                  _buildPerformanceMetrics(profile, responderPro),
                  ],
                 ),
               ),
             )
            ],
          );
        },
      ),
    );
  }

  // Performance metrics section
  Widget _buildPerformanceMetrics(ProfileProvider profile, ResponderProvider responderPro) {
    return Column(
      children: [
        profile.currentUserProfile?.type == "POLICE"
            ? _performanceMetricTile("Incident Outcome", "Arrests", "user_hands", responderPro.homeMetrics?.numberOfArrest.toString() ?? "0",
                const Color(0xffFF1E0F).withOpacity(0.2),
                has2: true, desc_2: "Escape", value2: responderPro.homeMetrics?.numberOfEscape.toString() ?? "0", onTap: () {})
            : _performanceMetricTile("Incident Outcome", "Fire Output", "user_hands", responderPro.homeMetrics?.numberOfFirePutOut.toString() ?? "0",
                const Color(0xffFF1E0F).withOpacity(0.2),
                has2: true, desc_2: "Fire Not Putout", value2: responderPro.homeMetrics?.numberOfFireNotPutOut.toString() ?? "0", onTap: () {}),
        AppSpaces.height8,
        _performanceMetricTile("Response Time", "Arrests", "clock1", "${responderPro.homeMetrics?.accumulatedResponseTime ?? "0"} min",
            const Color(0xff0085FF).withOpacity(0.2),
            has2: false),
        AppSpaces.height8,
        _performanceMetricTile("Average On-scene Time", "Arrests", "pointer", "${responderPro.homeMetrics?.accumulatedTurnaroundTime ?? "0"} min",
            const Color(0xff7A71D1).withOpacity(0.2),
            has2: false),
      ],
    );
  }

  // Active Emergencies header
  Widget _buildActiveEmergenciesHeader(bool show) {
    return GestureDetector(
      onTap: () => isShowList.value = !show,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Active emergencies", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          IconButton(
              onPressed: () => isShowList.value = !show,
              icon: Icon(show ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_outlined)),
        ],
      ),
    );
  }

  // Emergency list
  Widget _buildEmergencyList(List<Map<String, dynamic>> activeEmergencyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpaces.height16,
        Column(
          children: List.generate(activeEmergencyData.length, (index) {
            return AcitivityTile(
              activeEmergency: activeEmergencyData[index],
              onTap: () => _onEmergencyTileTap(activeEmergencyData[index]),
            );
          }),
        ),
      ],
    );
  }

  void _onEmergencyTileTap(Map<String, dynamic> emergencyData) {
    final responderPro = context.read<ResponderProvider>();
    responderPro.getEmergencyReportById(context, emergencyData['emergency_id']);
    if (emergencyData['status'] == "ON-ROUTE" && responderPro.emergencyRes.emergency?.id != null) {
      AppNavigationHelper.navigateToWidget(context, RespondToEmergency(reporterData: responderPro.emergencyRes.emergency!));
    }
    if (emergencyData['status'] == "CONNECTING") {
      AppNavigationHelper.navigateToWidget(context, ResponderEmergencyDetails(emergencyData: emergencyData));
    }
  }

  void _showEmergencyAlertDialogOnce(List<Map<String, dynamic>> activeEmergencyData) async {
    var sharedPrefsManager = SharedPrefManager();
    bool viewOnce = await sharedPrefsManager.getViewAlert();
    if (activeEmergencyData.isNotEmpty && activeEmergencyData[0]['status'] == "CONNECTING" && !viewOnce) {
      sharedPrefsManager.setViewNewAlert(true);
      Future.delayed(Duration(seconds: 1), () {
        notificationDialog(
          onTap: () {
            AppNavigationHelper.navigateToWidget(
              context,
              ResponderEmergencyDetails(emergencyData: activeEmergencyData[0]),
            );
          },
          title: 'New Emergency Alert',
          message: "New Emergency with ID ${activeEmergencyData[0]['emergency_id']} and severity is ${activeEmergencyData[0]['severity']}, Please Accept Now",
        );
      });
    }
  }
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
              radius: 25,
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
                          ? _buildStatColumn(desc_2 ?? "", value2 ?? "", has2)
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
