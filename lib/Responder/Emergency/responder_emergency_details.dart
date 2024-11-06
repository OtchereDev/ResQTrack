import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/image_viewer.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Map/map_provider.dart';
import 'package:resq_track/Provider/Report/report_provider.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Responder/Emergency/responder_to_emergency.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Views/MapViews/map_view_with_cordinate.dart';
import 'package:resq_track/Views/MapViews/map_with_polyline.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class ResponderEmergencyDetails extends StatefulWidget {
  final dynamic emergencyData;
  const ResponderEmergencyDetails({super.key, this.emergencyData});

  @override
  State<ResponderEmergencyDetails> createState() =>
      _ResponderEmergencyDetailsState();
}

class _ResponderEmergencyDetailsState extends State<ResponderEmergencyDetails> {
  @override
  void initState() {
    // TODO: implement initState
    // print("----Init---------------${widget.emergencyData['emergency_id']}===============");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResponderProvider>(context, listen: false)
          .getEmergencyReportById(
              context, widget.emergencyData['emergency_id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResponderProvider>(
        builder: (context, responderProvider, _) {
      return Consumer<ReportProvider>(builder: (context, report, _) {
         
        return Scaffold(
          backgroundColor: AppColors.WHITE,
          body: report.isLoading
              ? LoadingPage()
              : Stack(
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
                            topRight: Radius.circular(30),
                          ),
                          color: AppColors.WHITE,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomButton(
                              title: 'Respond To Emergency',
                              onTap: () {
                                if (responderProvider
                                        .emergencyRes.emergency?.id !=
                                    null) {
                                  responderProvider.acceptRequest(context,
                                      widget.emergencyData['emergency_id']);
                                  SharedPrefManager().setViewNewAlert(false);
                                  AppNavigationHelper.navigateToWidget(
                                      context,
                                      RespondToEmergency(
                                          reporterData: responderProvider
                                              .emergencyRes.emergency!));
                                }
                              },
                              color: AppColors.GREEN,
                            ),
                            const SizedBox(height: 16),
                            const Expanded(child: EmergencyDetailsTab()),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: Platform.isIOS ? 0 : 20),
                        child: const SafeArea(child: BackArrowButton()),
                      ),
                    ),
                  ],
                ),
        );
      });
    });
  }
}

class EmergencyDetailsTab extends StatefulWidget {
  const EmergencyDetailsTab({super.key});

  @override
  State<EmergencyDetailsTab> createState() => _EmergencyDetailsTabState();
}

class _EmergencyDetailsTabState extends State<EmergencyDetailsTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResponderProvider>(builder: (context, responderPro, _) {
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
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                const SingleChildScrollView(
                  child: EmergencyInfoTabView(),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textHeader("Allergies"),
                      AppSpaces.height16,
                      _buildAllergyRow(),
                      AppSpaces.height16,
                      _buildAllergyRow(),
                      AppSpaces.height16,
                      textHeader("Chronic Illnesses"),
                      AppSpaces.height16,
                      _buildAllergyRow(),
                      AppSpaces.height16,
                      _buildAllergyRow(),
                      AppSpaces.height16,
                      textHeader("Fatal Conditions"),
                      AppSpaces.height16,
                      _buildAllergyRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAllergyRow() {
    return Row(
      children: [
        _allergyCheckView("Angina"),
        _allergyCheckView("Medical Condition"),
      ],
    );
  }
}

Widget _allergyCheckView(String title) {
  return Expanded(
    child: Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.YELLOW,
          size: 18,
        ),
        AppSpaces.width8,
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
}

class EmergencyInfoTabView extends StatelessWidget {
  const EmergencyInfoTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResponderProvider>(builder: (context, responderPRo, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textHeader('Date'),
          AppSpaces.height8,
          Text(
            "${responderPRo.emergencyRes.emergency?.createdAt}",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          AppSpaces.height20,
          textHeader("Description"),
          AppSpaces.height8,
          Text(
            "${responderPRo.emergencyRes.emergency?.description}",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          AppSpaces.height20,
          textHeader("Victim Location"),
          AppSpaces.height8,
          MyLocationAndDestinationCard(
            source: "${responderPRo.emergencyRes.emergency?.locationName}",
          ),
          const SizedBox(height: 16),
          textHeader("Severity level"),
          AppSpaces.height4,
          LinearProgressIndicator(
            value: responderPRo.emergencyRes.emergency?.severity == "HIGH"
                ? 1.0
                : 0.4,
            color: responderPRo.emergencyRes.emergency?.severity == "HIGH"
                ? AppColors.RED
                : AppColors.GREEN,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 16),
          textHeader("Photos and videos"),
          AppSpaces.height8,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  responderPRo.emergencyRes.emergency?.photos?.length ?? 0,
                  (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 100,
                    width: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: (){
                          showDialog(context: context, builder: (context){
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ImageViewer(url:  responderPRo
                                      .emergencyRes.emergency?.photos?[index] ??""),
                            );
                          });
                        },
                        child: CachedNetworkImage(
                            imageUrl: responderPRo
                                    .emergencyRes.emergency?.photos?[index] ??
                                ""),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }
}
