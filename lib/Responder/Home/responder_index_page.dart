import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Provider/Call/new_call.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Responder/Home/responder_homee_page.dart';
import 'package:resq_track/Responder/Home/responder_profile_info.dart';
import 'package:resq_track/Responder/RespondeMapView/map_with_pointers.dart';

class ResponderBaseHomePage extends StatefulWidget {
  final int? initialIdex;
  const ResponderBaseHomePage({super.key, this.initialIdex});

  @override
  State<ResponderBaseHomePage> createState() => _ResponderBaseHomePageState();
}

class _ResponderBaseHomePageState extends State<ResponderBaseHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _selectedIndex = widget.initialIdex ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getUser(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MapWithPointers(),
      const Center(child: Text("Training Model")),
      const ResponderProfile(),
    ];
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: SizedBox(
              width: 23,
              height: 23,
              child: SvgPicture.asset(
                "assets/icons/home.svg",
                color: AppColors.BLACK,
              ),
            ),
            icon: SvgPicture.asset(
              "assets/icons/home.svg",
              color: const Color(0xff7C8293),
              height: 30,
              width: 30,
            ),
            label: ('Home'),
          ),
          BottomNavigationBarItem(
            activeIcon: SizedBox(
              width: 23,
              height: 23,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SvgPicture.asset(
                  "assets/icons/book.svg",
                  color: AppColors.BLACK,
                ),
              ),
            ),
            icon: SvgPicture.asset(
              "assets/icons/book.svg",
              height: 30,
              width: 30,
            ),
            label: ('Appointments'),
          ),
          BottomNavigationBarItem(
            activeIcon: SizedBox(
              width: 23,
              height: 23,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SvgPicture.asset(
                  "assets/icons/user.svg",
                  color: AppColors.BLACK,
                ),
              ),
            ),
            icon: SvgPicture.asset(
              "assets/icons/user.svg",
              height: 30,
              width: 30,
            ),
            label: ('Appointments'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.PRIMARY_COLOR,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
