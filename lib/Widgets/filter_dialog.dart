import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Utils/DatePicker/date_picker_util.dart';
import 'package:resq_track/Views/Home/RecentPage/recents.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';

class FilterWidget extends StatelessWidget {
  FilterWidget({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: AppColors.WHITE,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter",
                style: GoogleFonts.annapurnaSil(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          AppSpaces.height16,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Emergency Type",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.BLACK),
                  ),
                  AppSpaces.height8,
                  CustomCheckTile(
                    onChanged: (val) {},
                    name: "Police emergency",
                  ),
                  CustomCheckTile(
                    onChanged: (val) {},
                    name: "Fire emergency",
                  ),
                  CustomCheckTile(
                    onChanged: (val) {},
                    name: "Medical emergency",
                  ),
                  AppSpaces.height16,
                  Text(
                    "Emergency Status",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.BLACK),
                  ),
                  AppSpaces.height8,
                  CustomCheckTile(
                    onChanged: (val) {},
                    name: "Resolved",
                  ),
                  CustomCheckTile(
                    onChanged: (val) {},
                    name: "Unresolved",
                  ),
                  AppSpaces.height20,
                  Row(
                    children: [
                      Expanded(
                        child: TextFormWidget(
                          controller,
                          '',
                          true,
                          prefixIcon: Icon(FeatherIcons.calendar),
                          hint: 'Aug 7, 2024',
                          onTap: () {
                            DatePickerUtil.pickDate(context,
                                title: 'Select From');
                          },
                        ),
                      ),
                      AppSpaces.width8,
                      Text(
                        "-",
                        style: TextStyle(fontSize: 20),
                      ),
                      AppSpaces.width8,
                      Expanded(
                        child: TextFormWidget(
                          controller,
                          '',
                          true,
                          prefixIcon: Icon(FeatherIcons.calendar),
                          hint: 'Aug 7, 2024',
                          onTap: () {
                            DatePickerUtil.pickDate(context,
                                title: 'Select To');
                          },
                        ),
                      )
                    ],
                  ),
                  AppSpaces.height40,
                  Row(
                    children: [
                      Expanded(child: CustomOutlinedButton(title: 'Cancel', onTap: (){
                        Navigator.pop(context);
                      },)),
                      AppSpaces.width16,
                      Expanded(child: CustomButton(title: 'Filter', onTap: (){
                        Navigator.pop(context);

                      },))
                    ],
                  ),
                  AppSpaces.height20
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
