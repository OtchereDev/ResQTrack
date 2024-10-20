import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatters {
  static List<String> countryCodes = ["+233", "+234", "+44", "+1"];
  static String removeZeroFormNumber(String number) {
    String correctNumber = "";
    if (number[0] == "0") {
      correctNumber = (number.substring(1));
    } else {
      correctNumber = (number);
    }
    return correctNumber;
  }

  static String formatToInternationNumber(String countryCode, String number) {
    if (number[0] == "+") {
      return number;
    }
    return countryCode + removeZeroFormNumber(number);
  }

  static String humanReadableDate(DateTime inputDate) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(Duration(days: 1));
  DateTime threeDaysAgo = today.subtract(Duration(days: 3));
  DateTime oneWeekAgo = today.subtract(Duration(days: 7));

  // Check if the date is today
  if (inputDate.isAtSameMomentAs(today)) {
    return 'Today';
  }

  // Check if the date is yesterday
  if (inputDate.isAtSameMomentAs(yesterday)) {
    return 'Yesterday';
  }

  // Check if the date is within the last 3 days (excluding today)
  if (inputDate.isAfter(threeDaysAgo) && inputDate.isBefore(today)) {
    int daysAgo = today.difference(inputDate).inDays;
    return '$daysAgo days ago';
  }

  // Check if the date is within the last week (but not within the last 3 days)
  if (inputDate.isAfter(oneWeekAgo) && inputDate.isBefore(threeDaysAgo)) {
    return 'Last week';
  }

  // For older dates, return the formatted date as a fallback
  return 'On ${inputDate.day}/${inputDate.month}/${inputDate.year}';
}


  static String removeCountryCode(String number) {
    String result = number
        .replaceAll('+233', '')
        .replaceAll('+234', '')
        .replaceAll("+1", "");
    return result;
  }

  static String getLocalNumber(String number) {
    if (number == '') return '';
    return number.substring(number.length - 9);
  }

  static String formatUserTime(String time) {
    String periodType = time.trim().substring(time.length - 2);
    String newTime = time.trim().substring(0, 5);

    return '$newTime $periodType';
  }

  static dynamic uTCDateFormat(DateTime dateTime) {
    var val = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
    var offset = dateTime.timeZoneOffset;
    var hours =
        offset.inHours > 0 ? offset.inHours : 1; // For fixing divide by 0

    if (!offset.isNegative) {
      val =
          "$val+${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    } else {
      val =
          "$val-${(-offset.inHours).toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    }
    return val;
  }

  static String getApproxTime(String movTime, String finishTime) {
    String periodType = "PM";
    final startTime = TimeOfDay(
        hour: int.parse(movTime.substring(0, 1)),
        minute: int.parse(movTime.substring(3, 4)));

    final endTime = TimeOfDay(
        hour: int.parse(finishTime.substring(0, 1)),
        minute: int.parse(finishTime.substring(3, 4)));

    var time = TimeOfDay(
        hour: startTime.hour + endTime.hour,
        minute: startTime.minute + endTime.minute);
    return "${time.hour}:${time.minute}$periodType";
  }

  static String getPayCardStr(String code) {
    final int length = code.length;
    final int replaceLength = length - 4;
    final String replacement =
        List<String>.generate((replaceLength / 4).ceil(), (int _) => '**** ')
            .join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  static String capitalizeEachWord(String input) {
  if (input.isEmpty) return input;

  // Split the input string by spaces or underscores
  List<String> words = input.split(RegExp(r'[_\s]+'));

  // Capitalize each word and join them with a space
  String capitalizedString = words.map((word) {
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');

  return capitalizedString;
}

}
