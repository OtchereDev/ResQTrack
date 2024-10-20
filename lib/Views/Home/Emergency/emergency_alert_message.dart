import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Views/Notification/notification_page.dart';
import 'package:resq_track/Widgets/back_arrow_button.dart';

class EmergencyAlertMessage extends StatelessWidget {
  const EmergencyAlertMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackArrowButton(),
                AppSpaces.height20,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SirenIcon(),
                    AppSpaces.width16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Active Shooter Alert!",
                            style: GoogleFonts.annapurnaSil(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          AppSpaces.height8,
                          Text(
                            "Stay Safe! Your immediate response is vital to your safety. Follow these instructions until law enforcement declares the situation secure.",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.RED,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpaces.height16,
                Text('''
            
            Issued
            Oct 10, 2024
            An active shooter has been reported at 143 Randall Avenue, Neasden. Law enforcement is on the scene and actively responding to the situation. At this time, it is critical that you take immediate action to protect yourself and others.
            Situation Overview
            Suspect details are currently unknown.
            Last seen at 143 Randall Avenue, Neasden.
            There are reports of 2 injuries. Please stay clear of the area.
            What You Should Do Right Now
            Run
            If you are in the vicinity of the shooter and can safely escape, leave the area immediately.
            Evacuate whether others agree to follow or not.
            Leave belongings behind, and help others escape if possible.
            
            Hide
            If escape isn’t possible, find a secure hiding place. Choose a room that is out of the shooter’s view, lock the door, and block entry with heavy furniture if necessary.
            Silence your phone and remain as quiet as possible. Turn off any lights or devices that could reveal your location.
            
            Fight (only as a last resort)
            If your life is in immediate danger and you have no other option, act with as much aggression as possible to incapacitate the shooter.
            Use improvised weapons (like chairs, fire extinguishers) to defend yourself.
            
            Stay Informed
            Follow official law enforcement updates via text alerts, social media, or local news.
            If you have critical information about the shooter’s whereabouts or identity, call 911 or your local emergency number.
            
            Avoid the Area
            If you are not in the immediate vicinity, do not travel to the location. Stay away and allow law enforcement to do their job.
            Important Contacts
            Emergency Services
            Dial 911 for any urgent information or to report suspicious activity.
            
            Local Authorities
            For updates and official statements, stay tuned to local law enforcement social media and news channels.
            ''')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
