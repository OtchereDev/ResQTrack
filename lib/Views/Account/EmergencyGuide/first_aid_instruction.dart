import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/search_text.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Views/Account/EmergencyGuide/emergency_guide_detail.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Views/Notification/notification_page.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/emergency_guide_tile.dart';

class FirstAidinstructionPage extends StatelessWidget {
  FirstAidinstructionPage({super.key});

  final filerValue = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                        "Emergency Guides",
                        style: GoogleFonts.annapurnaSil(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      AppSpaces.height20,
                      textHeader("First Aid Instructions"),
                      AppSpaces.height16,
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
                              onTap: () {},
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 0.6, color: AppColors.BLACK)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      'assets/icons/filter.svg'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpaces.height20,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ValueListenableBuilder(
                            valueListenable: filerValue,
                            builder: (context, filter, _) {
                              return Row(
                                children:
                                    List.generate(_filter.length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CustomChip(
                                      isActive: index == filter,
                                      title: _filter[index],
                                      onTap: () {
                                        filerValue.value = index;
                                      },
                                    ),
                                  );
                                }),
                              );
                            }),
                      ),
                      AppSpaces.height16,
                     ...List.generate(3, (index){
                      return  EmergencyGuideTile(onTap: (){
                        AppNavigationHelper.navigateToWidget(context, EmergencyGuideDetail());
                      },);
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
List<String> _filter = [
  "All",
  "Unresponsive breathing casualties",
  "Airway and breathing problems"
];
