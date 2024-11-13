import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Provider/Setup/setup_provider.dart';
import 'package:resq_track/Views/Account/account_page.dart';
import 'package:resq_track/Views/Home/Sos/sos_page.dart';
import 'package:resq_track/Views/Home/RecentPage/recents.dart';
import 'package:resq_track/Views/MapViews/map_home.dart';
import 'package:resq_track/Views/Settings/settings_page.dart';
import 'package:resq_track/Widgets/custom_bottom_nav.dart';

class BaseHomePage extends StatefulWidget {
  final int? initialIdex;
  const BaseHomePage({super.key, this.initialIdex});

  @override
  State<BaseHomePage> createState() => _BaseHomePageState();
}

class _BaseHomePageState extends State<BaseHomePage> {
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
      context.read<LocationProvider>().getCurrentLocation();
      context.read<ProfileProvider>().getUser(context);
      Provider.of<SetupProvider>(context, listen: false).updateFcmToken();

      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      const MapHomePage(),//const ActiveEmergencyPage(), //
       RecentPage(),
      const AccountPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
          bottomNavigationBar: CustomBottomNavBar(onChange: _onItemTapped,isActive: _selectedIndex,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigationHelper.navigateToWidget(context, SosPage());
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        backgroundColor: const Color(0xffFF5549),
        child: Text(
          "SOS",
          style: GoogleFonts.annapurnaSil(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.WHITE),
        ),
      ),
    );
  }
}
