import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/image_viewer.dart';
import 'package:resq_track/Model/Response/guide_response_mode.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';

class EmergencyGuideDetail extends StatefulWidget {

final Guide guide;

  EmergencyGuideDetail({super.key, required this.guide});

  @override
  State<EmergencyGuideDetail> createState() => _EmergencyGuideDetailState();
}

class _EmergencyGuideDetailState extends State<EmergencyGuideDetail> {
  final filerValue = ValueNotifier(0);


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      var responderPro = Provider.of<ResponderProvider>(context, listen: false);
      responderPro.getSingleGuide(context, widget.guide.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Consumer<ResponderProvider>(
          builder: (context, responder, _) {
            return responder.isLoading ? const LoadingPage(): Padding(
             padding:  EdgeInsets.only(left: 20.0, top:Platform.isIOS ? 0: 20, right: 20),
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
                            "${responder.singleGuide?.category?.name}",
                            style: GoogleFonts.annapurnaSil(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          AppSpaces.height20,
                          textHeader("First Aid Instructions"),
                          AppSpaces.height16,
                          ImageViewer(url:responder.singleGuide?.image ??""),
                          AppSpaces.height20,
                          Text(
                            responder.singleGuide?.title ??"",
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w900),
                          ),
                          AppSpaces.height8,
                          Text(
                            responder.singleGuide?.content ??"",
                            style: const TextStyle(fontSize: 12),
                          ),
                          AppSpaces.height16,
                         
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

