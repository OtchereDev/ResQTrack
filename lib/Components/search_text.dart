import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_track/AppTheme/app_config.dart';

class SearchText extends StatelessWidget {
  final Function(String text) search;
  const SearchText({super.key, required this.search});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: search,
      decoration: InputDecoration(
        hintText: 'Search...',
        alignLabelWithHint: true,
        hintStyle:
            GoogleFonts.raleway(color: const Color(0xff4D5061), fontSize: 11),
        filled: true,
        prefixIcon: const Icon(
          FeatherIcons.search,
          size: 15,
        ),
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide:
              const BorderSide(color: AppColors.TEXTFIELD_BORDER, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide:
              const BorderSide(color: AppColors.TEXTFIELD_BORDER, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide:
              const BorderSide(color: AppColors.TEXTFIELD_BORDER, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 0.6,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
