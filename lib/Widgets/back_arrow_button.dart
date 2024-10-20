
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:resq_track/AppTheme/app_config.dart';

class BackArrowButton extends StatelessWidget {
  const BackArrowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>Navigator.pop(context),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 10, 
              offset: Offset(0, 4),
              color: AppColors.BLACK.withOpacity(0.1)
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SvgPicture.asset('assets/icons/back_arrow.svg'),
        ),
      ),
    );
  }
}