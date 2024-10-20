import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Components/textformfield.dart';
import 'package:resq_track/Provider/Profile/profile_provider.dart';
import 'package:resq_track/Utils/Loaders/loader_utils.dart';
import 'package:resq_track/Views/Home/home_dialog.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class PersonalInfoPage extends StatefulWidget {
  PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
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
            child: profile.isLoading ? LoadingPage(): Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                      textHeader("Personal Info"),
                      AppSpaces.height16,
                      Row(
                        children: [
                          CircleAvatar(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xff667085)),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text("Edit"),
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
