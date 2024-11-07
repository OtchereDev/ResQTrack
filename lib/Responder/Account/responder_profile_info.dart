import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class ResponderProfile extends StatefulWidget {
  const ResponderProfile({super.key});

  @override
  State<ResponderProfile> createState() => _ResponderProfileState();
}

class _ResponderProfileState extends State<ResponderProfile> {
  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var profile = Provider.of<ProfileProvider>(context, listen: false);
      nameController.text = profile.getUserFullname();
      emailController.text = profile.currentUserProfile?.email ?? "";
      phoneController.text = profile.currentUserProfile?.phoneNumber ?? "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: Consumer<ProfileProvider>(builder: (context, profile, _) {
          return SafeArea(
            child: profile.isLoading ? const LoadingPage(): Padding(
              padding:  EdgeInsets.only(left: 20.0, top:Platform.isIOS ? 0: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profile",
                        style: GoogleFonts.annapurnaSil(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      AppSpaces.height16,
                      textHeader("Personal Info"),
                      AppSpaces.height16,
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                "https://avatar.iran.liara.run/public"),
                          ),
                          AppSpaces.width20,
                          GestureDetector(
                            onTap: () {
                              profile.selectProfileImages();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xff667085)),
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Text("Edit"),
                            ),
                          )
                        ],
                      ),
                      AppSpaces.height20,
                      TextFormWidget(nameController, 'Name', false),
                      AppSpaces.height20,
                      TextFormWidget(phoneController, 'Phone', false),
                      AppSpaces.height20,
                      TextFormWidget(emailController, 'Email', true)
                    ],
                  )
                ],
              ),
            ),
          );
        }
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(
          title: 'Save',
          onTap:context.watch<ProfileProvider>().isLoading ? null : () {
            var profile = Provider.of<ProfileProvider>(context, listen: false);
            profile
                .updateProfile(
                    context, nameController.text, phoneController.text)
                .then((val) {
              if (val == true) {
                profile.getUser(context, fromRemote: true);
              }
            });
          },
        ),
      ),
    );
  }
}
