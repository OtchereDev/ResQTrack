// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';
import 'package:resq_track/Utils/properties.dart';

class TextFormWidget extends StatefulWidget {
  TextFormWidget(this.textController, this.title, this.enabled,
      {this.isPhone = false,
      this.validate = false,
      this.validateEmail = false,
      this.inputType,
      this.validateMsg,
      this.hint,
      this.icon,
      this.iconColor,
      this.onIconTap,
      this.formater,
      this.prefixIcon,
      this.count,
      this.onValueChange,
      this.padding = const EdgeInsets.symmetric(horizontal: 12,),
      this.onTap, this.line, this.onEditComplete});
  TextEditingController textController = TextEditingController();
  final String? title, hint;
  final String? validateMsg;
  bool enabled, validateEmail, isPhone;
  bool validate;
  final void Function()? onIconTap;
  final VoidCallback? onTap;
  final VoidCallback? onEditComplete;
  final Color? iconColor;
  final IconData? icon;
  final Widget? prefixIcon;
  final EdgeInsets? padding;
  final TextInputType? inputType;
  final List<TextInputFormatter>? formater;
  final int? count, line;
  Function(String)? onValueChange;

  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  bool isActive = true;
  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      widget.title!.isEmpty ? const SizedBox.shrink():  Text(
          widget.title!,
          style:  const TextStyle(color: AppColors.DEFAULT_TEXT, fontSize: 14),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          onTap: widget.onTap,
          controller: widget.textController,
          keyboardType: widget.inputType,
          onEditingComplete:widget.onEditComplete,
          maxLength: widget.count,
          onChanged: widget.onValueChange,
          inputFormatters: widget.formater,
          readOnly: widget.enabled,
          maxLines: widget.line,
          validator: (value) {
            RegExp regex = RegExp(PATTERN);
            if (widget.validateEmail && !regex.hasMatch(value!)) {
              return "Please enter a valid email address";
            }
            if(widget.validate && value!.isEmpty){
              return widget.validateMsg;
            }
            return null;
          },
          focusNode: null,
          decoration: InputDecoration(
              hintText: widget.hint,
              alignLabelWithHint: true,
              hintStyle:  GoogleFonts.raleway(color: const Color(0xff4D5061)),
              filled: true,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.icon == null
                  ? null
                  : GestureDetector(
                      onTap: widget.onIconTap,
                      child: Icon(widget.icon, color: widget.iconColor),
                    ),
              fillColor: Colors.white,
              contentPadding: widget.padding,
              enabledBorder: isActive
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.TEXTFIELD_BORDER, width: 1),
                    )
                  : InputBorder.none,
              focusedBorder: isActive
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppColors.TEXTFIELD_BORDER, width: 1),
                    )
                  : InputBorder.none,
              border: isActive
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.TEXTFIELD_BORDER, width: 1),
                    )
                  : InputBorder.none,
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 0.6,
                  color: Colors.red,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              )),
        ),
      ],
    );
  }
}
