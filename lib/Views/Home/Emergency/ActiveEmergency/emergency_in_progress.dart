import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Provider/Call/new_call.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Map/map_provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Provider/Setup/setup_provider.dart';
import 'package:resq_track/Services/Firbase/request_api.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Views/MapViews/map_view_with_cordinate.dart';
import 'package:resq_track/Views/MapViews/map_with_polyline.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';
import 'dart:io';

class EmergencyInProgress extends StatelessWidget {
  final String responderID;
  EmergencyInProgress({super.key, required this.responderID});

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var callPro = Provider.of<SetupProvider>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<dynamic>(
          stream: RequestApi().getResponderLocation(
              responderID), // Listen for responder location
          builder: (context, snapshot) {
            var locationData;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Loading indicator
            }

            if (snapshot.hasError) {
              // print(snapshot.error);
              return Center(child: Text("${snapshot.error}"));
            }

            if (snapshot.hasData) {
              locationData = snapshot.data as Map<String, dynamic>;
              Provider.of<MapProvider>(context, listen: false)
                  .fetchPolylinePoints(context,
                      latitude: locationData['latitude'],
                      longitude: locationData['longitude'])
                  .then((coordinates) {
                if (coordinates != null) {
                  // Generate polyline from the fetched coordinates
                  Provider.of<MapProvider>(context, listen: false)
                      .generatePolyLineFromPoints(coordinates);
                }
              });
              return Consumer<ProfileProvider>(builder: (context, profile, _) {
                var user = profile.currentUserProfile;
                return Stack(
                  children: [
                    MapScreenWidthCordinate(
                      showButton: false,
                      latLng: LatLng(
                          locationData['latitude'], locationData['longitude']),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                        height: Utils.screenHeight(context) / 1.5,
                        width: Utils.screenWidth(context),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: AppColors.WHITE,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Emergency response in progress....",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              AppSpaces.height16,
                              const Text("Officers arriving in:"),
                              AppSpaces.height16,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    color: AppColors.YELLOW,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text(
                                  "02:34 Mins",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              AppSpaces.height16,
                              const Divider(),
                              AppSpaces.height16,
                              MyLocationAndDestinationCard(
                                source: locationData['locationName'],
                              ),
                              AppSpaces.height16,
                              const Divider(),
                              AppSpaces.height16,
                              const Text("Live communication"),
                              Row(
                                children: [
                                  Expanded(
                                      child: TextFormWidget(
                                    textController,
                                    "",
                                    true,
                                    hint: 'Chat with responders....',
                                  )),
                                  AppSpaces.width8,
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: CircleAvatar(
                                        backgroundColor: const Color(0xff667085)
                                            .withOpacity(0.2),
                                        child: SvgPicture.asset(
                                            'assets/icons/phone.svg')),
                                  ),
                                  AppSpaces.width8,
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        CallModel callModel = CallModel(
                                          id: 'call_${UniqueKey().hashCode.toString()}',
                                          callerId: user!.id,
                                          callerName: user.name,
                                          status: CallStatus.ringing.name,
                                          createAt: DateTime.now()
                                              .microsecondsSinceEpoch,
                                          receiverId: locationData['userId'],
                                          receiverName: locationData['name'],
                                          current: true
                                        );
                                            callPro.fireVideoCall(context, callModel: callModel).then((val){
                                              AppNavigationHelper.navigateToWidget(context, const AgoraMyApp()); //CallScreen(isReceiver: false, callModel: callModel));
                                            });
                                      },
                                      child: CircleAvatar(
                                          backgroundColor:
                                              const Color(0xff667085)
                                                  .withOpacity(0.2),
                                          child: SvgPicture.asset(
                                              'assets/icons/video.svg')),
                                    ),
                                  ),
                                ],
                              ),
                              AppSpaces.height16,
                              const Divider(),
                              AppSpaces.height16,
                              CustomOutlinedButton(
                                title: 'Cancel Emergency Report',
                                onTap: () {},
                                color: AppColors.RED,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: SafeArea(child: BackArrowButton()),
                      ),
                    ),
                  ],
                );
              });
            }

            return Stack(
              children: [
                const MapWithPolylinePage(),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    height: Utils.screenHeight(context) / 1.5,
                    width: Utils.screenWidth(context),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: AppColors.WHITE,
                    ),
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Emergency response in progress....",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            AppSpaces.height16,
                            const Text("Officers arriving in:"),
                            AppSpaces.height16,
                            InkWell(
                              onTap: () {
                                print("===========$locationData=========");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    color: AppColors.YELLOW,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text(
                                  "02:34 Mins",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            AppSpaces.height16,
                            const Divider(),
                            AppSpaces.height16,
                            const MyLocationAndDestinationCard(
                              source: "Source",
                            ),
                            AppSpaces.height16,
                            const Divider(),
                            AppSpaces.height16,
                            const Text("Live communication"),
                            Row(
                              children: [
                                Expanded(
                                    child: TextFormWidget(
                                  textController,
                                  "",
                                  true,
                                  hint: 'Chat with responders....',
                                )),
                                AppSpaces.width8,
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CircleAvatar(
                                      backgroundColor: const Color(0xff667085)
                                          .withOpacity(0.2),
                                      child: SvgPicture.asset(
                                          'assets/icons/phone.svg')),
                                ),
                                AppSpaces.width8,
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // print("===========$locationData=========");
                                    },
                                    child: CircleAvatar(
                                        backgroundColor: const Color(0xff667085)
                                            .withOpacity(0.2),
                                        child: SvgPicture.asset(
                                            'assets/icons/video.svg')),
                                  ),
                                ),
                              ],
                            ),
                            AppSpaces.height16,
                            const Divider(),
                            AppSpaces.height16,
                            CustomOutlinedButton(
                              title: 'Cancel Emergency Report',
                              onTap: () {},
                              color: AppColors.RED,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20, top: Platform.isIOS ? 0 : 20),
                    child: const SafeArea(child: BackArrowButton()),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class MyLocationAndDestinationCard extends StatelessWidget {
  final String source;
  const MyLocationAndDestinationCard({
    super.key,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(builder: (context, location, _) {
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
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icons/taxi.svg'),
                ),
              ),
              AppSpaces.width8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dispatch location",
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    source,
                    style: const TextStyle(color: AppColors.BLACK),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            width: 40,
            child: Column(
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Container(
                    height: 5,
                    width: 2,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                );
              }),
            ),
          ),
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: const Color(0xff275DAD).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icons/my_loc.svg'),
                ),
              ),
              AppSpaces.width8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your locaiton",
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    "${location.locationMessage}",
                    style: const TextStyle(color: AppColors.BLACK),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(),
              )
            ],
          )
        ],
      );
    });
  }
}
