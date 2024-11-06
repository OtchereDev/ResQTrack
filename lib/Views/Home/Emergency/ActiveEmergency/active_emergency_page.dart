import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Map/map_provider.dart';
import 'package:resq_track/Provider/Report/report_provider.dart';
import 'package:resq_track/Services/Firbase/request_api.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Views/Home/Emergency/ActiveEmergency/emergency_in_progress.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Views/MapViews/map_view.dart';
import 'package:resq_track/Views/MapViews/map_view_with_cordinate.dart';
import 'package:resq_track/Widgets/custom_app_bar.dart';
import 'package:resq_track/Widgets/emergency_alert.dart';
import 'package:resq_track/Widgets/emergency_button.dart';
import 'package:resq_track/Widgets/recent_emergency.dart';
import 'package:resq_track/Widgets/safety_tips.dart';

class ActiveEmergencyPage extends StatefulWidget {
  final String responderID;
  const ActiveEmergencyPage({super.key, required this.responderID});

  @override
  State<ActiveEmergencyPage> createState() => _ActiveEmergencyPageState();
}

class _ActiveEmergencyPageState extends State<ActiveEmergencyPage> {
  @override
  void initState() {
    super.initState();

    // Fetch the emergency report as soon as the page is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false)
          .getEmergencyReport(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: StreamBuilder<dynamic>(
        stream: RequestApi().getResponderLocation(
            widget.responderID), // Listen for responder location
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
            // return locationData;
          }

          // Fallback to the report provider if there's no location data
          return Consumer<ReportProvider>(
            builder: (context, report, _) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAppBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppSpaces.height16,
                              textHeader("Active Emergency"),
                              Stack(
                                children: [
                                  // Map view background
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: locationData != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: MapScreenWidthCordinate(
                                              showButton: false,
                                              latLng: LatLng(
                                                  locationData['latitude'],
                                                  locationData['longitude']),
                                            ),
                                          )
                                        :  MapScreen(height: Utils.screenHeight(context),),
                                  ),
                                  // Transparent GestureDetector over the map
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to the Emergency in Progress page
                                        AppNavigationHelper.navigateToWidget(
                                            context,
                                            EmergencyInProgress(
                                              responderID: widget.responderID,
                                            ));
                                      },
                                      child: Container(
                                        color: Colors
                                            .transparent, // Transparent overlay
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AppSpaces.height20,
                              const Text(
                                "Emergency alert",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              AppSpaces.height16,
                              EmergencyAlertContainer(
                                onTap: () {
                                  // Handle Emergency Alert Tap
                                },
                              ),
                              AppSpaces.height20,
                              const Text(
                                "Emergency services",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              AppSpaces.height8,
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  EmergencyButton(
                                    icon: 'police2',
                                    title: "Police",
                                  ),
                                  EmergencyButton(
                                    icon: 'fire2',
                                    title: "Fire Rescue",
                                  ),
                                  EmergencyButton(
                                    icon: 'ambulance2',
                                    title: "Ambulance",
                                  ),
                                ],
                              ),
                              AppSpaces.height20,
                              viewMoreButton("Recent emergencies", () {}),
                              AppSpaces.height8,
                              // Show recent emergencies from the report provider
                              ...List.generate(
                                report.emergencyRes.emergencies
                                        ?.take(1)
                                        .length ??
                                    0,
                                (index) {
                                  return RecentEmergencyContainer(
                                    report:
                                        report.emergencyRes.emergencies![index],
                                  );
                                },
                              ),
                              AppSpaces.height20,
                              viewMoreButton("Safety tips", () {}),
                              AppSpaces.height8,
                              const SafetyTipsContainer(),
                              AppSpaces.height20,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
