import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackArrowButton(),
              AppSpaces.height20,
              Text(
                "Language Settings",
                style: GoogleFonts.annapurnaSil(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
              AppSpaces.height16,
              const Text(
                "Suggested Languages ",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.DEFAULT_TEXT),
              ),
              AppSpaces.height20,
              const ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: Text("Default", style: TextStyle(fontSize: 8),),
                  title: Text("English(UK)", style: TextStyle(fontSize: 12),), trailing: Icon(Icons.check),),
                  const Divider(height: 0,),
                  const ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: Text("Default", style: TextStyle(fontSize: 8),),
                  title: Text("French", style: TextStyle(fontSize: 12),), trailing: Icon(Icons.check),),
                   const Divider(height: 0,),
                  const ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: Text("Default", style: TextStyle(fontSize: 8),),
                  title: Text("French", style: TextStyle(fontSize: 12),), trailing: Icon(Icons.check),),
            const Divider(height: 0,),
                  const ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: Text("Default", style: TextStyle(fontSize: 8),),
                  title: Text("French", style: TextStyle(fontSize: 12),), trailing: Icon(Icons.check),),
                const Divider(height: 0,),
                  const ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: Text("Default", style: TextStyle(fontSize: 8),),
                  title: Text("French", style: TextStyle(fontSize: 12),), trailing: Icon(Icons.check),),
                    const Divider(height: 0,),
                  AppSpaces.height8,
             
                   
            ],
          ),
        ),
      ),
    );
  }
}
