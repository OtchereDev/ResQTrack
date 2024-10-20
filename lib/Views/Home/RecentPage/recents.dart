import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/search_text.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Provider/Report/report_provider.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Utils/formatters.dart';
import 'package:resq_track/Views/Home/RecentPage/report_details.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Widgets/filter_dialog.dart';

class RecentPage extends StatefulWidget {
  RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false)
          .getEmergencyReport(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: Consumer<LocationProvider>(builder: (context, location, _) {
        return Consumer<ReportProvider>(builder: (context, report, _) {
          return report.isLoading ? LoadingPage(): SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Emergency Reports",
                    style: GoogleFonts.annapurnaSil(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  AppSpaces.height20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 9,
                          child: SizedBox(
                              height: 36,
                              child: SearchText(search: (search) {}))),
                      AppSpaces.width8,
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return FilterWidget();
                                });
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 0.6, color: AppColors.BLACK)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  SvgPicture.asset('assets/icons/filter.svg'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpaces.height20,
                  ...List.generate(report.emergencyRes.emergencies?.length ?? 0,
                      (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Formatters.humanReadableDate(
                              report.emergencyRes.emergencies?[index].id ??
                                  DateTime.now()),
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.BLACK),
                        ),
                        AppSpaces.height16,
                        ...List.generate(
                            report.emergencyRes.emergencies?[index].emergencies
                                    ?.length ??
                                0, (inx) {
                          var data = report
                              .emergencyRes.emergencies?[index].emergencies;
                          return ReportTile(
                            description: data?[inx].description ?? "",
                            title: "${Formatters.capitalizeEachWord(data?[inx].emergencyType??"")} Emergency",
                            isSuccess: data?[inx].status == "RESOLVED",
                            emergencyType: data?[inx].emergencyType ?? "",
                            onTap: () {
                              AppNavigationHelper.navigateToWidget(
                                  context,  ReportDetails(emergency: data![inx],));
                            },
                          );
                        })
                      ],
                    );
                  })
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}

class CustomCheckTile extends StatefulWidget {
  final Function(bool?)? onChanged;
  final String name;
  const CustomCheckTile({
    super.key,
    this.onChanged,
    required this.name,
  });

  @override
  State<CustomCheckTile> createState() => _CustomCheckTileState();
}

class _CustomCheckTileState extends State<CustomCheckTile> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => isChecked = !isChecked);
        widget.onChanged?.call(isChecked);
      },
      child: Container(
        width: double.infinity,
        height: 40,
        child: Row(
          children: [
            Icon(
              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              size: 15,
              color: isChecked ? AppColors.PRIMARY_COLOR : AppColors.BLACK,
            ),
            AppSpaces.width8,
            Text(
              widget.name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isSuccess;
  final String title, description;
  final String emergencyType;
  const ReportTile({
    super.key,
    required this.isSuccess,
    required this.description,
    this.onTap,
    required this.title,
    required this.emergencyType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
          child: Row(
            children: [
              CircleAvatar(
                child: SvgPicture.asset(
                    'assets/icons/${emergencyType == "POLICE" ? "police2" : emergencyType == "AMBULANCE" ? "ambulance2" : "fire2"}.svg'),
                backgroundColor: const Color(0xffFFEDF1),
              ),
              AppSpaces.width16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textHeader(title),
                        StatusContainer(isSuccess: isSuccess)
                      ],
                    ),
                    AppSpaces.height8,
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StatusContainer extends StatelessWidget {
  const StatusContainer({
    super.key,
    required this.isSuccess,
  });

  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: !isSuccess
              ? AppColors.RED.withOpacity(0.2)
              : AppColors.GREEN.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        isSuccess ? "Resolved" : "Unresolved",
        style: TextStyle(
            fontSize: 8, color: !isSuccess ? AppColors.RED : AppColors.GREEN),
      ),
    );
  }
}
