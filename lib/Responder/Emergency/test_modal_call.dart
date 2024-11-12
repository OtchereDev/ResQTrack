import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resq_track/Services/fcm/notification.dart';
import 'package:resq_track/Widgets/call_widget.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

class TestModalCall extends StatelessWidget {
  const TestModalCall({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(title: 'Show Modal', onTap: (){
              // Get.dialog(CallWidget());
            },)
          ],
        ),
      ),
    );
  }
}