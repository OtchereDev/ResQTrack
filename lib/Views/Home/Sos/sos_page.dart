import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Core/Extensions/extensions.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Model/Request/emergency_request_body.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Report/report_provider.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Views/Home/index.dart';
import 'package:resq_track/Views/MapViews/map_view.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/confirm_create_report.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';
import 'package:resq_track/Widgets/emergency_type_selector.dart';

class SosPage extends StatelessWidget {
  SosPage({super.key});

  final emergencyType = ValueNotifier(10);
  final sliderValue = ValueNotifier(0.1);

  final textController = TextEditingController();

  final scfKey = GlobalKey<ScaffoldState>();
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scfKey,
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<ReportProvider>(builder: (context, report, _) {
          return report.isLoading
              ? const LoadingPage()
              : Padding(
                  padding: EdgeInsets.only(
                      left: 20, right: 20, top: Platform.isIOS ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BackArrowButton(),
                      AppSpaces.height20,
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SOS",
                                style: GoogleFonts.annapurnaSil(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              AppSpaces.height16,
                              textHeader("Report Incident"),
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child:  MapScreen(height: Utils.screenHeight(context) * 0.5,),
                              ),
                              AppSpaces.height20,
                              textHeader(
                                "What emergency response do you need?",
                              ),
                              AppSpaces.height8,
                              ValueListenableBuilder(
                                  valueListenable: emergencyType,
                                  builder: (context, selected, _) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                          emergencyTypeList.length, (index) {
                                        return EmergencyTypeSelect(
                                          isActive: selected == index,
                                          title: emergencyTypeList[index]
                                              ['name'],
                                          icon: emergencyTypeList[index]
                                              ['icon'],
                                          onTap: () {
                                            emergencyType.value = index;
                                          },
                                        );
                                      }),
                                    );
                                  }),
                              AppSpaces.height20,
                              textHeader(
                                "How severe is the situation?",
                              ),
                              ValueListenableBuilder(
                                  valueListenable: sliderValue,
                                  builder: (context, slide, _) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SliderTheme(
                                          data: SliderThemeData(
                                            // here
                                            trackShape: CustomTrackShape(),
                                          ),
                                          child: Slider(
                                            value: slide,
                                            onChanged: (val) {
                                              sliderValue.value = val;
                                            },
                                            activeColor: slide <= 0.4
                                                ? AppColors.PRIMARY_COLOR
                                                : slide <= 0.7
                                                    ? AppColors.YELLOW
                                                    : AppColors.RED,
                                          ),
                                        ),
                                        Text(
                                          "Severity level: ${slide <= 0.4 ? "low" : slide <= 0.7 ? "medium" : "high"}",
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xff7C8293)),
                                        )
                                      ],
                                    );
                                  }),
                              AppSpaces.height20,
                              textHeader(
                                "Describe the situation.",
                              ),
                              AppSpaces.height8,
                              TextFormWidget(
                                textController,
                                '',
                                false,
                                line: 7,
                                hint: 'Use keywords',
                                focusNode: focusNode,
                              ),
                              AppSpaces.height20,
                              textHeader(
                                "Add photos and videos of the situation",
                              ),
                              AppSpaces.height8,
                              GestureDetector(
                                onTap: () {
                                  report.selectProfileImages();
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      const Color(0xff667085).withOpacity(0.2),
                                  child: SvgPicture.asset(
                                      'assets/icons/camera.svg'),
                                ),
                              ),
                              AppSpaces.height16,
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(report.images.length,
                                      (index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: SizedBox(
                                        height: 100,
                                        width: 130,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              File(report.images[index].path),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: context.watch<ReportProvider>().isLoading
            ? const SizedBox.shrink()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    title: 'Report Incident',
                    onTap: () async {
                      focusNode.requestFocus();
                      var report = context.read<ReportProvider>();
                      List<String> urls = await report.uploadImage(context);
                      if (urls.isNotEmpty) {
                        var location =
                            scfKey.currentContext!.read<LocationProvider>();
                        EmergencyRequest _emer = EmergencyRequest();

                        _emer.description = textController.text;
                        _emer.emergencyType =
                            emergencyTypeList[emergencyType.value]['key']
                                .toString()
                                .toUpperCase();
                        _emer.severity = sliderValue.value <= 0.4
                            ? "LOW"
                            : sliderValue.value <= 0.7
                                ? "MEDIUM"
                                : "HIGH";

                        _emer.location = "${location.currentPosition?.latitude},${location.currentPosition?.longitude}";
                        _emer.photos = urls;
                        _emer.locationName = location.locationMessage;
                        report.createEmergency(context, _emer).then((val) {
                          if (val == true) {
                            AppNavigationHelper.setRootOldWidget(
                                context, const BaseHomePage());
                          }
                        });
                      }
                    },
                  ),
                  AppSpaces.height16,
                  const CustomOutlinedButton(title: 'Cancel')
                ],
              ),
      ),
    );
  }
}

List<Map<String, dynamic>> emergencyTypeList = [
  {"icon": "police2", "name": "Police", "key": "POLICE"},
  {"icon": "ambulance2", "name": "Ambulance", "key": "AMBULANCE"},
  {
    "icon": "fire2",
    "name": Platform.isIOS ? "Fire Rescue" : "Fire\nRescue",
    "key": "FIRE"
  },
];
