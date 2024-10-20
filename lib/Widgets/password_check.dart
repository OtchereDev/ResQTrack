
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PasswordCriteriaRow extends StatelessWidget {
  final bool criteriaMet;
  final String text;

  const PasswordCriteriaRow({
    Key? key,
    required this.criteriaMet,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
          criteriaMet ? SvgPicture.asset("assets/icons/check.svg") : SvgPicture.asset("assets/icons/x.svg"),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 11, color: Color(0xff667085)),),
      ],
    );
  }
}
