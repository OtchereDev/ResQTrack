import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
      {super.key,
      this.fieldKey,
      @required this.hintText,
      this.onSaved,
      this.validate = false,
      this.removeBorder = false,
      this.onFieldSubmitted,
      required this.controller,
      required this.validateMsg,
      this.focusNode,
      required this.inputType,
      this.title,
      this.rightWidget,
      this.onValueChange});
  final Key? fieldKey;
  final String? hintText, title, validateMsg;
  final FormFieldSetter<String>? onSaved;
  final bool? validate, removeBorder;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController controller;
  final TextInputType? inputType;
  final Widget? rightWidget;
  final Function(String)? onValueChange;

  final FocusNode? focusNode;
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  // bool isActive = true;
  // bool _isPasswordMoreThanEight = false;
  // bool _hasNumber = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      // final regEx = RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%&*?])');
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title!,
          style: const TextStyle(color: AppColors.DEFAULT_TEXT, fontSize: 14),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          key: widget.fieldKey,
          obscureText: _obscureText,
          onSaved: widget.onSaved,
          keyboardType: widget.inputType,
          validator: (value) {
            if (value!.isEmpty && widget.validate!) {
              return widget.validateMsg;
            }
            // if (!_hasNumber && widget.validate!) {
            //   return "Password must have at least one special charater ";
            // }
            if (value.length < 8 && widget.validate!) {
              return "Password must be atleast eight characters";
            }
            return null;
          },
          onFieldSubmitted: widget.onFieldSubmitted,
          controller: widget.controller,
          onChanged: widget.onValueChange,
          // style: TextStyle(color: Color(0xffF7F7F7)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12,),
            hintText: widget.hintText,
            focusColor: const Color(0xffF7F7F7),
            // prefixIcon: Padding(
            //   padding: const EdgeInsets.all(14.0),
            //   child: SvgPicture.asset(
            //     "assets/icons/lock.svg",
            //     color: AppColors.DIFCOLOR,
            //   ),
            // ),

            // labelStyle: const TextStyle(color: AppColors.ASHDEEP),
            // contentPadding: EdgeInsets.only(left: 10),
            hintStyle:  GoogleFonts.raleway(color: Color(0xff4D5061)),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.TEXTFIELD_BORDER, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.TEXTFIELD_BORDER, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.TEXTFIELD_BORDER, width: 1),
            ),
            // : InputBorder.none,
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 0.6,
                color: Colors.red,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Icon(
                          FeatherIcons.eye,
                          color: AppColors.TEXTFIELD_BORDER,
                        ))
                    : const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Icon(
                          FeatherIcons.eyeOff,
                          color: AppColors.TEXTFIELD_BORDER,
                        ))),
          ),
        ),
        widget.rightWidget ?? const SizedBox.shrink(),
        widget.rightWidget == null
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
