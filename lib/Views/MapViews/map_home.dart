import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Services/Firbase/request_api.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Utils/utils.dart';
import 'package:resq_track/Views/Home/Emergency/ActiveEmergency/active_emergency_page.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Views/MapViews/map_view.dart';
import 'package:resq_track/Widgets/custom_app_bar.dart';
import 'dart:io';

class MapHomePage extends StatelessWidget {
  const MapHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var reportID;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reportID = await SharedPrefManager().getActiveEmergency();
    });
    return Consumer<ProfileProvider>(builder: (context, profile, _) {
      return StreamBuilder<dynamic>(
          stream: RequestApi().filterEmergencyById(
              reportID ?? "671a67f002c331abf0f4a6cf",
              profile.currentUserProfile?.id ?? ""),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['status'] == "ON-ROUTE") {
                return ActiveEmergencyPage(
                  responderID: snapshot.data['responder_id'],
                );
              }

              if (snapshot.data['status'] == "CONNECTING") {
                return Stack(
                  children: [
                     MapScreen(height: Utils.screenHeight(context),),
                    Align(
                        alignment: Alignment.center,
                        child: LottieBuilder.asset(
                            'assets/images/searching.json')),
                  ],
                );
              }
            }

            return Stack(
              children: [
                 MapScreen(height: Utils.screenHeight(context) * 0.5,),
                const Align(
                    alignment: Alignment.bottomCenter, child: HomeDialog()),
                SafeArea(
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: Platform.isIOS ? 0 : 20.0, right: 20, left: 20),
                      child: const CustomAppBar()),
                )
              ],
            );
          });
    });
  }
}
