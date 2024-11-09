


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/image_viewer.dart';
import 'package:resq_track/Components/search_text.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Responder/Learn/tutorial_detail_page.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';

class VideoTrainingTabView extends StatelessWidget {
  const VideoTrainingTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ResponderProvider>(
      builder: (context, responder, _) {
        return responder.isLoading ? LoadingPage(): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 9,
                    child: SizedBox(
                        height: 36, child: SearchText(search: (search) {}))),
                AppSpaces.width8,
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 0.6, color: AppColors.BLACK)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icons/filter.svg'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AppSpaces.height20,
            ...List.generate(responder.tutorialModel?.data.tutorials.length ?? 0, (index) {
              var tutorial = responder.tutorialModel?.data.tutorials[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: (){
                    AppNavigationHelper.navigateToWidget(context, TutorialDetailPage(tutorialId: tutorial!));
                  },
                  child: SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        ClipRRect(
                          child: ImageViewer(url:tutorial?.image ??"", height: 150, width: double.infinity,),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              "${tutorial?.title}",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.WHITE),
                            ))
                      ],
                    ),
                  ),
                ),
              );
            })
          ],
        );
      }
    );
  }
}

