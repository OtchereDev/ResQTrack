import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/notification_popup.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackArrowButton(),
              AppSpaces.height20,
              Text(
                "Notification",
                style: GoogleFonts.annapurnaSil(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
              AppSpaces.height16,
              Row(
                children: List.generate(filter.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CustomChip(title: filter[index],isActive: index ==0,),
                  );
                }),
              ),
              AppSpaces.height20,
              ...List.generate(7, (index){
                return Column(
                  children: [
                    ListTile(
                      onTap: (){
                        notificationDialog(title: 'Active shooter alert', message: 'Active shooter reported in the lobby of XYZ Corporation. Seek immediate shelter, lock doors, silence phones. Contact 911. Await further instructions.');
                      },
                    contentPadding: EdgeInsets.zero,
                    leading: SirenIcon(),
                    title: textHeader('Hurricane alert'),
                    subtitle: Text("Persons around the greater London area are warned about strong winds, heavy rains....", style: TextStyle(fontSize: 12, color: AppColors.DEFAULT_TEXT),),
                                  ),
              Divider(),

                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final bool isActive;
  final String title;
  final VoidCallback? onTap;
  const CustomChip({
    super.key, required this.isActive, required this.title, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            color: isActive
                ? AppColors.PRIMARY_COLOR
                : AppColors.WHITE,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
                color: isActive
                    ? AppColors.PRIMARY_COLOR
                    : Color(0xff667085))),
        child: Text(
          title,
          style: TextStyle(
              color: isActive
                  ? AppColors.WHITE
                  : Color(0xff667085),
              fontSize: 10,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class SirenIcon extends StatelessWidget {
  const SirenIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.RED.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: SvgPicture.asset('assets/icons/siren.svg'),
      ),
    );
  }
}

List<String> filter = ["All", "Alerts", "Safety Tips"];
