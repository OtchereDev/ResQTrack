// // ignore_for_file: overridden_fields, annotate_overrides

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// abstract class AppTheme {
//   static AppTheme of(BuildContext context) {
//     return LightModeTheme();
//   }

//   late Color primaryColor;
//   late Color secondaryColor;
//   late Color tertiaryColor;
//   late Color alternate;
//   late Color primaryBackground;
//   late Color secondaryBackground;
//   late Color primaryText;
//   late Color secondaryText;

//   late Color primaryBtnText;
//   late Color lineColor;
//   late Color grayIcon;
//   late Color gray200;
//   late Color gray600;
//   late Color black600;
//   late Color tertiary400;
//   late Color textColor;

//   String get title1Family => typography.title1Family;

//   TextStyle get title1 => typography.title1;

//   String get title2Family => typography.title2Family;

//   TextStyle get title2 => typography.title2;

//   String get title2WhiteFamily => typography.title2WhiteFamily;

//   TextStyle get title2White => typography.title2White;

//   String get title3Family => typography.title3Family;

//   TextStyle get title3 => typography.title3;

//   String get subtitle1Family => typography.subtitle1Family;

//   TextStyle get subtitle1 => typography.subtitle1;

//   String get subtitle2Family => typography.subtitle2Family;

//   TextStyle get subtitle2 => typography.subtitle2;

//   String get bodyText1Family => typography.bodyText1Family;

//   TextStyle get bodyText1 => typography.bodyText1;

//   String get bodyText2Family => typography.bodyText2Family;

//   TextStyle get bodyText2 => typography.bodyText2;

//   Typography get typography => ThemeTypography(this);
// }

// class LightModeTheme extends AppTheme {
//   late Color primaryColor = const Color(0xFF764ABC);
//   late Color secondaryColor = const Color(0xFF39D2C0);
//   late Color tertiaryColor = const Color(0xFFEE8B60);
//   late Color alternate = const Color(0xFFFF5963);
//   late Color primaryBackground = const Color(0xFFF1F4F8);
//   late Color secondaryBackground = const Color(0xFFFFFFFF);
//   late Color primaryText = const Color(0xFF101213);
//   late Color secondaryText = const Color(0xFF57636C);

//   late Color primaryBtnText = Color(0xFFFFFFFF);
//   late Color lineColor = Color(0xFFE0E3E7);
//   late Color grayIcon = Color(0xFF95A1AC);
//   late Color gray200 = Color(0xFFDBE2E7);
//   late Color gray600 = Color(0xFF262D34);
//   late Color black600 = Color(0xFF090F13);
//   late Color tertiary400 = Color(0xFF39D2C0);
//   late Color textColor = Color(0xFF1E2429);
// }

// abstract class Typography {
//   String get title1Family;

//   TextStyle get title1;

//   String get title2Family;

//   TextStyle get title2;

//   String get title2WhiteFamily;

//   TextStyle get title2White;

//   String get title3Family;

//   TextStyle get title3;

//   String get subtitle1Family;

//   TextStyle get subtitle1;

//   String get subtitle2Family;

//   TextStyle get subtitle2;

//   String get bodyText1Family;

//   TextStyle get bodyText1;

//   String get bodyText2Family;

//   TextStyle get bodyText2;
// }

// class ThemeTypography extends Typography {
//   ThemeTypography(this.theme);

//   final AppTheme theme;

//   String get gettitle1Family => 'Custom';

//   String get title1Family => 'Custom';

//   TextStyle get title1 => GoogleFonts.mulish(
//         color: theme.primaryText,
//         fontWeight: FontWeight.w600,
//         fontSize: 24,
//       );

//   // TextStyle get title1 => GoogleFonts.getFont(
//   //   'Custom',
//   //   color: theme.primaryText,
//   //   fontWeight: FontWeight.w600,
//   //   fontSize: 24,
//   // );
//   String get title2Family => 'Custom';

//   // TextStyle get title2 => GoogleFonts.getFont(
//   //   'Custom',
//   //   color: theme.secondaryText,
//   //   fontWeight: FontWeight.w600,
//   //   fontSize: 22,
//   // );
//   TextStyle get title2 => TextStyle(
//       color: theme.primaryText,
//       fontWeight: FontWeight.w600,
//       fontSize: 18,
//       fontFamily: "Poppins");

//   String get title2WhiteFamily => 'Custom';

//   TextStyle get title2White => TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.w600,
//         fontSize: 20,
//       );

//   String get title3Family => 'Custom';

//   TextStyle get title3 => TextStyle(
//       color: theme.primaryText,
//       fontWeight: FontWeight.w600,
//       fontSize: 20,
//       fontFamily: "Poppins");

//   String get subtitle1Family => 'Custom';

//   TextStyle get subtitle1 =>
//       TextStyle(color: theme.primaryText, fontSize: 18, fontFamily: "Poppins");

//   String get subtitle2Family => 'Custom';

//   TextStyle get subtitle2 => GoogleFonts.karla(
//       color: theme.primaryText, fontSize: 17, fontWeight: FontWeight.w700);

//   String get bodyText1Family => 'Custom';

//   TextStyle get bodyText1 => GoogleFonts.montserrat(
//         fontSize: 17,
//         color: theme.primaryText,
//       );

//   // TextStyle get bodyText1 => TextStyle(
//   //   color: theme.primaryText,
//   //   // fontWeight: FontWeight.w600,
//   //   fontSize: 16,
//   // );

//   String get bodyText2Family => 'Custom';

//   TextStyle get bodyText2 => TextStyle(
//         color: theme.primaryText,
//         fontWeight: FontWeight.w600,
//         fontSize: 12,
//       );
// }

// extension TextStyleHelper on TextStyle {
//   TextStyle override({
//     String? fontFamily,
//     Color? color,
//     double? fontSize,
//     FontWeight? fontWeight,
//     double? letterSpacing,
//     FontStyle? fontStyle,
//     bool useGoogleFonts = true,
//     TextDecoration? decoration,
//     double? lineHeight,
//   }) =>
//       useGoogleFonts
//           ? GoogleFonts.getFont(
//               fontFamily!,
//               color: color ?? this.color,
//               fontSize: fontSize ?? this.fontSize,
//               letterSpacing: letterSpacing ?? this.letterSpacing,
//               fontWeight: fontWeight ?? this.fontWeight,
//               fontStyle: fontStyle ?? this.fontStyle,
//               decoration: decoration,
//               height: lineHeight,
//             )
//           : copyWith(
//               fontFamily: fontFamily,
//               color: color,
//               fontSize: fontSize,
//               letterSpacing: letterSpacing,
//               fontWeight: fontWeight,
//               fontStyle: fontStyle,
//               decoration: decoration,
//               height: lineHeight,
//             );
// }
