import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:resq_track/AppTheme/app_config.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int index) onChange;
  final int isActive;
  const CustomBottomNavBar({super.key, required this.onChange, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      
      shadowColor: Colors.black,
      shape: const CircularNotchedRectangle(), // For the floating button space
      notchMargin: 8.0, // The space between the button and the bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/home.svg",
              color: isActive == 0 ? AppColors.BLACK: Color(0xff7C8293)  ,
              height: 30,
              width: 30,
            ),
            onPressed: () {
              onChange(0);
              // Home action
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/clock.svg",
                   color: isActive == 1 ? AppColors.BLACK: null ,
              height: 25,
              width: 25,
            ),
            onPressed: () {
              onChange(1);
            },
          ),
          const SizedBox(width: 40), // Space for the SOS button
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/user.svg",
                   color: isActive == 2 ? AppColors.BLACK: null ,

              height: 30,
              width: 30,
            ),
            onPressed: () {
              onChange(2);
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/settings.svg",
                   color: isActive == 3 ? AppColors.BLACK: null ,

              height: 30,
              width: 30,
            ),
            onPressed: () {
              onChange(3);
            },
          ),
        ],
      ),
    );
  }
}
