import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Model/Response/emergency_response.dart';
import 'package:resq_track/Provider/Report/report_provider.dart';
import 'package:resq_track/Services/Firbase/request_api.dart';
import 'package:resq_track/Utils/formatters.dart';
import 'package:resq_track/Views/Home/Emergency/ActiveEmergency/emergency_in_progress.dart';
import 'package:resq_track/Views/Home/RecentPage/recents.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Views/MapViews/map_view_with_cordinate.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';

class ReportDetails extends StatefulWidget {
  final EmergencyEmergency emergency;
  const ReportDetails({super.key, required this.emergency});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false)
          .getEmergencyReportById(context, widget.emergency.id);
      // RequestApi().filterEmergencyById(widget.emergency.id??"");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: 20.0, top: Platform.isIOS ? 0 : 20, right: 20),
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
                        "${Formatters.capitalizeEachWord(widget.emergency.emergencyType ?? "")} Emergency",
                        style: GoogleFonts.annapurnaSil(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      AppSpaces.height20,
                      textHeader('Status'),
                      AppSpaces.height8,
                      StatusContainer(
                          isSuccess: widget.emergency.status == "RESOLVED"),
                      AppSpaces.height20,
                      textHeader('Date'),
                      AppSpaces.height8,
                      const Text("Aug 23, 2024  09:21 AM"),
                      AppSpaces.height20,
                      textHeader('Location'),
                      AppSpaces.height8,
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: widget
                                .emergency.location!.coordinates!.isNotEmpty
                            ? InkWell(
                              onTap: (){
                                //  AppNavigationHelper.navigateToWidget(
                                //             context,
                                //             EmergencyInProgress(
                                //               responderID: widget.emergency.responder,
                                //             ));
                              },
                              child: MapScreenWidthCordinate(
                                  latLng: LatLng(
                                      widget.emergency.location!.coordinates![0],
                                      widget.emergency.location!.coordinates![1]),
                                ),
                            )
                            : null,
                      ),
                      AppSpaces.height20,
                      textHeader('Description'),
                      AppSpaces.height8,
                      Text(
                        widget.emergency.description ?? "",
                        style: const TextStyle(fontSize: 12),
                      ),
                      AppSpaces.height20,
                      textHeader('Severity level'),
                      AppSpaces.height8,
                      LinearProgressIndicator(
                        value: widget.emergency.severity == "LOW"
                            ? 0.4
                            : widget.emergency.severity == "MEDIUM"
                                ? 0.7
                                : 1.0,
                        color: widget.emergency.severity == "LOW"
                            ? AppColors.GREEN
                            : widget.emergency.severity == "MEDIUM"
                                ? Colors.orange
                                : Colors.red,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      AppSpaces.height4,
                      Text(
                        "${widget.emergency.severity}",
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xff7C8293)),
                      ),
                      AppSpaces.height20,
                      textHeader('Photos and videos'),
                      AppSpaces.height8,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: widget.emergency.photos!.isEmpty
                            ? const Text("No Image added")
                            : Row(
                                children: List.generate(
                                    widget.emergency.photos?.length ?? 0,
                                    (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: SizedBox(
                                      height: 100,
                                      width: 130,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                              widget.emergency.photos?[index])),
                                    ),
                                  );
                                }),
                              ),
                      ),
                      AppSpaces.height20,
                      textHeader('Communication'),
                      AppSpaces.height8,
                      ...List.generate(3, (index) {
                        return CommunicationTile(
                          title: 'Outgoing voice call',
                          icon: index == 1 ? 'audio_call' : 'video_call',
                          desc: "3:21",
                        );
                      })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommunicationTile extends StatelessWidget {
  final String icon, title, desc;
  const CommunicationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
            backgroundColor: const Color(0xffF9C80E).withOpacity(0.2),
            child: SvgPicture.asset('assets/icons/$icon.svg'),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          subtitle: Text(
            desc,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}
