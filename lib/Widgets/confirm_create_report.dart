

import 'package:flutter/material.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';
import 'package:resq_track/Widgets/custom_outlined_button.dart';

class ConfirmCreatDialog extends StatelessWidget {
  final VoidCallback? onContinue, onCancel;
  const ConfirmCreatDialog({
    super.key, this.onContinue, this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Do you want to report this \nemergency?"),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          AppSpaces.height16,
          Text(
            "Your report will be sent to first responders, who will attend to you.",
            style: TextStyle(
                fontSize: 12,
                color: AppColors.DEFAULT_TEXT),
          ),
          AppSpaces.height16,
          CustomButton(
            title: 'Send Report',
            onTap: ()  {
              onContinue!();
              Navigator.pop(context);
             
            },
          ),
          AppSpaces.height16,
          CustomOutlinedButton(
            title: 'Cancel',
            onTap:onCancel
          ),
          AppSpaces.height20
        ],
      ),
    );
  }
}
