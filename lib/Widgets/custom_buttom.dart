
import 'package:flutter/cupertino.dart';
import 'package:resq_track/AppTheme/app_config.dart';

class CustomButton extends StatelessWidget {
 final String title;
  final VoidCallback? onTap;
  const CustomButton({
    super.key, required this.title, this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(child:  Text(title), onPressed: onTap, borderRadius: BorderRadius.circular(50),color: AppColors.PRIMARY_COLOR,));
  }
}
