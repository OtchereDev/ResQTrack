import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Model/Response/responder_respond_model.dart';
import 'package:resq_track/Provider/Call/call_provider.dart';
import 'package:resq_track/Provider/Call/new_call.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Map/map_provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Provider/Setup/setup_provider.dart';
import 'package:resq_track/Responder/Emergency/responder_emergency_details.dart';
import 'package:resq_track/Responder/ResponderChat/responder_chat.dart';
import 'package:resq_track/Services/Firbase/request_api.dart';
import 'package:resq_track/Utils/Dialogs/notifications.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Views/Chat/user_chat.dart';
import 'package:resq_track/Views/MapViews/map_view_with_cordinate.dart';
import 'package:resq_track/Views/MapViews/map_with_polyline.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/default_circle_image.dart';
import 'package:resq_track/Widgets/user_info_header.dart';

class RespondToEmergency extends StatefulWidget {
  final Emergency reporterData;
  RespondToEmergency({super.key, required this.reporterData});

  @override
  State<RespondToEmergency> createState() => _RespondToEmergencyState();
}

class _RespondToEmergencyState extends State<RespondToEmergency>
    with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var callPro = Provider.of<SetupProvider>(context, listen: false);


    var callProvider = Provider.of<CallProvider>(context);
    return Scaffold(
      body: StreamBuilder<dynamic>(
        stream: RequestApi()
            .getReporterlocation(widget.reporterData.user?.id ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          if (snapshot.hasData) {
            final locationData = snapshot.data as Map<String, dynamic>;

            return Consumer<ProfileProvider>(builder: (context, profile, _) {
              var user = profile.currentUserProfile;

             
              //       // Check for specific call states
              if (callProvider.callStatus == "ErrorUnAnsweredVideoChatState") {
                NotificationUtils.showToast(context,
                    message: 'Unexpected Error: ${callProvider.callStatus}');
              } else if (callProvider.callStatus ==
                      "DownCountCallTimerFinishState" &&
                  callProvider.remoteUid == null) {
                // callProvider.updateCallStatusToUnAnswered(
                //     CallModel.fromJson(callData).id);
              } else if (callProvider.callStatus == "CallNoAnswerState") {
                NotificationUtils.showToast(context, message: 'No response!');
                Navigator.pop(context);
              } else if (callProvider.callStatus == "CallCancelState") {
                NotificationUtils.showToast(context,
                    message: 'Caller cancelled the call!');
                Navigator.pop(context);
              } else if (callProvider.callStatus == "CallRejectState") {
                NotificationUtils.showToast(context,
                    message: 'Receiver rejected the call!');
              } else if (callProvider.callStatus == "CallEndState") {
                NotificationUtils.showToast(context, message: 'Call ended!');
                Navigator.pop(context);
              }

                return Stack(
                children: [
                  MapScreenWidthCordinate(
                    showButton: false,
                    latLng: LatLng(
                      widget.reporterData.location!.coordinates![0],
                      widget.reporterData.location!.coordinates![1],
                    ),
                  ),
                  _buildBottomContainer(context, user, locationData, callPro),
                  const Positioned(
                    top: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: SafeArea(child: BackArrowButton()),
                    ),
                  ),
                ],
              );
            }
                        );
          }

          return _buildLoadingMap();
        },
      ),
    );
  }

  Future<void> _fetchPolylinePoints(
      BuildContext context, Map<String, dynamic> locationData) async {
    final coordinates = await Provider.of<MapProvider>(context, listen: false)
        .fetchPolylinePoints(context,
            latitude: locationData['latitude'],
            longitude: locationData['longitude']);
    if (coordinates != null) {
      Provider.of<MapProvider>(context, listen: false)
          .generatePolyLineFromPoints(coordinates);
    }
  }

  Widget _buildBottomContainer(BuildContext context, dynamic user,
      Map<String, dynamic> locationData, SetupProvider callPro) {
    var loc = context.read<LocationProvider>();
    var profile = context.read<ProfileProvider>();
    var res = context.watch<ResponderProvider>();
    res.calculateETA(
        context,
        "${widget.reporterData.location!.coordinates![1]},${widget.reporterData.location!.coordinates![0]}",
        "${loc.currentPosition?.latitude},${loc.currentPosition?.longitude}");

    return Positioned(
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        height: Utils.screenHeight(context) / 1.5,
        width: Utils.screenWidth(context),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: AppColors.WHITE,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Responding to emergency...",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  IconButton(
                      onPressed: () {
                        AppNavigationHelper.navigateToWidget(
                          context,
                          MapScreenWidthCordinate(
                            showButton: true,
                            latLng: LatLng(
                                widget.reporterData.location!.coordinates![1],
                                widget.reporterData.location!.coordinates![0]),
                          ),
                        );
                      },
                      icon: const Icon(FeatherIcons.mapPin))
                ],
              ),
              AppSpaces.height16,
              const Text("Arriving in:"),
              AppSpaces.height16,
              _buildArrivalTime(res),
              AppSpaces.height16,
              MyLocationAndDestinationCard(
                  source: widget.reporterData.locationName ?? ""),
              AppSpaces.height16,
              const Text("Live communication"),
              _buildChatAndCallRow(
                  context, user, locationData, callPro, profile),
              AppSpaces.height16,
              const Divider(),
              _buildTabBar(res),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArrivalTime(ResponderProvider pro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.YELLOW, borderRadius: BorderRadius.circular(12)),
      child: Text("${pro.travelTimeText ?? "0 mins"}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildChatAndCallRow(
      BuildContext context,
      dynamic user,
      Map<String, dynamic> locationData,
      SetupProvider callPro,
      ProfileProvider profile) {
    return Row(
      children: [
        Expanded(
          child: TextFormWidget(
            textController,
            "",
            true,
            hint: 'Chat with responders...',
            onTap: () {
              AppNavigationHelper.navigateToWidget(
                  context,
                  RespondeerChatScreen(
                    recipientId: locationData['userID'],
                    senderId: profile.currentUserProfile?.id ?? "",
                  ));
            },
          ),
        ),
        AppSpaces.width8,
        _buildChatButton(),
        AppSpaces.width8,
        _buildCallButton(context, user, locationData, callPro),
      ],
    );
  }

  Widget _buildChatButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: CircleAvatar(
        backgroundColor: const Color(0xff667085).withOpacity(0.2),
        child: SvgPicture.asset('assets/icons/phone.svg'),
      ),
    );
  }

  Widget _buildCallButton(BuildContext context, dynamic user,
      Map<String, dynamic> locationData, SetupProvider callPro) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {
          CallModel callModel = CallModel(
            id: 'call_${UniqueKey().hashCode}',
            callerId: user!.id,
            callerName: user.name,
            status: CallStatus.ringing.name,
            createAt: DateTime.now().microsecondsSinceEpoch,
            receiverId: locationData['userID'],
            receiverName: locationData['name'],
            current: true,
          );

          callPro.fireVideoCall(context, callModel: callModel).then((_) {
            AppNavigationHelper.navigateToWidget(context,  AgoraMyApp(callModel: callModel,));
          });
        },
        child: CircleAvatar(
          backgroundColor: const Color(0xff667085).withOpacity(0.2),
          child: SvgPicture.asset('assets/icons/video.svg'),
        ),
      ),
    );
  }

  Widget _buildTabBar(ResponderProvider pro) {
    return Column(
      children: [
        TabBar(
          dividerHeight: 0,
          labelColor: AppColors.PRIMARY_COLOR,
          indicatorColor: AppColors.PRIMARY_COLOR,
          tabs: const [
            Tab(text: "Emergency Info"),
            Tab(text: "Victim Details"),
          ],
          controller: tabController,
        ),
        AppSpaces.height20,
        SizedBox(
          height: 200, // Set a fixed height for the TabBarView
          child: TabBarView(
            controller: tabController,
            children: [
              const SingleChildScrollView(child: EmergencyInfoTabView()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${widget.reporterData.user?.name ?? ""}"),
                  AppSpaces.height16,
                  Text(
                      "Phone number: ${widget.reporterData.user?.phoneNumber ?? ""}"),
                  AppSpaces.height16,
                  Text("Email: ${widget.reporterData.user?.email ?? ""}")
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingMap() {
    return const Stack(
      children: [
        MapWithPolylinePage(),
        Positioned(
          top: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SafeArea(child: BackArrowButton()),
          ),
        ),
      ],
    );
  }
}

class MyLocationAndDestinationCard extends StatelessWidget {
  final String source;

  const MyLocationAndDestinationCard({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, location, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xff275DAD).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/icons/my_loc.svg'),
                  ),
                ),
                AppSpaces.width8,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Victim location",
                        style: TextStyle(fontSize: 10)),
                    Text(source,
                        style: const TextStyle(color: AppColors.BLACK)),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

