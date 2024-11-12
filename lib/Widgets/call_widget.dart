import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Model/Response/call_model.dart';
import 'package:resq_track/Provider/Call/call_provider.dart';
import 'package:resq_track/Provider/Call/new_call.dart';

class CallWidget extends StatelessWidget {
  final CallModel callModel;
  const CallWidget({super.key, required this.callModel});

  @override
  Widget build(BuildContext context) {
    var callProvider = Provider.of<CallProvider>(context, listen: false);
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: 250,
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.WHITE,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 8,
                color: AppColors.BLACK.withOpacity(0.1),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Incoming Call",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.BLACK,
                ),
              ),
              const SizedBox(height: 8),
              const Icon(
                Icons.phone_in_talk,
                size: 40,
                color: AppColors.GREEN,
              ),
              const SizedBox(height: 8),
              Text(
                "Caller: ${callModel.callerName}",
                style: const TextStyle(fontSize: 16, color: AppColors.PRIMARY_COLOR),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle accept call
                      callProvider.updateCallStatusToAccept(callModel);
                      Get.back();
                      AppNavigationHelper.navigateToWidget(
                          context,  AgoraMyApp(callModel: callModel,));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.GREEN,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.call, color: AppColors.WHITE),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      callProvider.performEndCall(callModel);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.RED,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.call_end, color: AppColors.WHITE),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
