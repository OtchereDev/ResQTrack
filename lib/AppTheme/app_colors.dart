// ignore_for_file: constant_identifier_names

part of 'app_config.dart';

class AppColors {
  static final Color primaryColor = HexColor.fromHex("0D6726");
  static const PRIMARY_COLOR = Color(0xff275DAD);
  static const SECONDARY_COLOR = Color(0xffE4ECFB);
  static const DEFAULT_TEXT = Color(0xff4D5061);
  static const TEXTFIELD_BORDER = Color(0xff667085);
  static const WHITE = Colors.white;
  static const BLACK = Colors.black;
  static const ASH_DEEP = Colors.grey;
  static const ASH = Color(0xffCCCCCC);
  static const GREY = Color(0xffEEEEEE);
  static const RED = Color(0xffFF5549);
  static const SEA_BLUE = Color(0xffB1E5F2);
  static const YELLOW = Color(0xffF9C80E);
  static const GREEN = Color(0xff12B76A);
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
