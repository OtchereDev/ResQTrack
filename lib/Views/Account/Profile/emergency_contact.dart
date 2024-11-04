import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Model/Response/user_response.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class EmergencyContactPage extends StatefulWidget {
   EmergencyContactPage({super.key});

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
final nameController = TextEditingController();

final phoneController = TextEditingController();

final emailController = TextEditingController();

@override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var sp = SharedPrefManager();
      User? user = await sp.getEmergency();
      nameController.text = user?.name ??"";
      emailController.text = user?.email ?? "";
      phoneController.text = user?.phoneNumber ??"";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
    padding:  EdgeInsets.only(left: 20.0, top:Platform.isIOS ? 0: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackArrowButton(),
              AppSpaces.height20,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: GoogleFonts.annapurnaSil(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  AppSpaces.height16,
                  textHeader("Emergency Contact"),
                  AppSpaces.height16,
                  
                  AppSpaces.height20,
                  TextFormWidget(nameController, 'Emergency Contact Name', true),
                   AppSpaces.height20,
                  TextFormWidget(phoneController, 'Emergency Contact Phone Number', true),
                   AppSpaces.height20,
                  TextFormWidget(emailController, 'Emergency Contact Email', true)
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(title: 'Save', onTap: (){},),
      ),
    );
  }
}
