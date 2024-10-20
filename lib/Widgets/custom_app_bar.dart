
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Views/Notification/notification_page.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          backgroundImage: NetworkImage("https://avatar.iran.liara.run/public"),
        ),
        InkWell(
          onTap: () {
            AppNavigationHelper.navigateToWidget(
                context, const NotificationPage());
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.WHITE,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 4))
                ]),
            child: SvgPicture.asset('assets/icons/notify.svg'),
          ),
        )
      ],
    );
  }
}
