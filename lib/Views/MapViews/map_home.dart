import 'package:flutter/material.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Views/MapViews/map_view.dart';
import 'package:resq_track/Widgets/custom_app_bar.dart';

class MapHomePage extends StatelessWidget {
  const MapHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        MapScreen(),
        Align(alignment: Alignment.bottomCenter, child: HomeDialog()),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:20.0),
            child: CustomAppBar()
          ),
        )
      ],
    );
  }
}

