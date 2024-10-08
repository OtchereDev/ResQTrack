import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';

class AppNavigationHelper {
  static navigateTo(
    context, {
    required String pageName,
  }) {
    return Navigator.pushNamed(context, pageName);
  }

  static navigateToWidget(context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }


  static navigateToWidgetAnimate(context, Widget widget) {
    // Get.to(widget,transition: Transition.circularReveal, duration: const Duration(milliseconds: 1000));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
  static navigateAndReplaceWidget(context, Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static navigateAndReplaceNamed(context, {required String pageName}) {
    return Navigator.pushReplacementNamed(context, pageName);
  }

  static Future setRootOldWidget(context, Widget page) async {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false,
    );
  }
}
