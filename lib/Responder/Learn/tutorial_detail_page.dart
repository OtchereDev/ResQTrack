import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/search_text.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Model/Response/tutorials_model.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/video_player.dart';
import 'package:resq_track/Widgets/video_thumbnail.dart';

class TutorialDetailPage extends StatefulWidget {
  final Tutorial tutorialId;
  const TutorialDetailPage({super.key, required this.tutorialId});

  @override
  State<TutorialDetailPage> createState() => _TutorialDetailPageState();
}

class _TutorialDetailPageState extends State<TutorialDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.value([
        Provider.of<ResponderProvider>(context, listen: false)
            .getTutorialDetails(context, widget.tutorialId.id),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<ResponderProvider>(
          builder: (context, pro, _) {
            return pro.isLoading ?  LoadingPage(): Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackArrowButton(),
                  AppSpaces.height16,
                  Text(widget.tutorialId.title),
                  AppSpaces.height16,
                  SizedBox(height: 36, child: SearchText(search: (search) {})),
                     AppSpaces.height20,

                 Expanded(
                   child: SingleChildScrollView(
                     child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                      ...List.generate( pro.tutorialDetailsModel!.data.tutorial.videos.length, (index){
                        return GestureDetector(
                          onTap: () {
                            AppNavigationHelper.navigateToWidget(context, YoutubePlayerDemoApp(videoUrl: pro.tutorialDetailsModel!.data.tutorial.videos[index],));
                          },
                          child: YouTubeThumbnail(videoUrl: pro.tutorialDetailsModel!.data.tutorial.videos[index]));
                      })
                      ],
                     ),
                   ),
                 )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
