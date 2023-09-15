/// Provide a utility class for processing time formatting
///
/// Copyright (C) 2023 The Authors
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Bowen Yang

import 'package:securedialog/utils/constants.dart';

/// this class is a util class to process time formatting
class TimeUtils {
  /// this method format a datetime into YYYYmmDD format
  /// @param dateTime - the current date time
  /// @return formattedTimeStr - formatted time
  static String getFormattedTimeYYYYmmDD(DateTime dateTime) {
    return dateTime.year.toString().padLeft(4, '0') +
        dateTime.month.toString().padLeft(2, '0') +
        dateTime.day.toString().padLeft(2, '0');
  }

  /// this method format a datetime into HHmmSS format
  /// @param dateTime - the current date time
  /// @return formattedTimeStr - formatted time
  static String getFormattedTimeHHmmSS(DateTime dateTime) {
    return dateTime.hour.toString().padLeft(2, '0') +
        dateTime.minute.toString().padLeft(2, '0') +
        dateTime.second.toString().padLeft(2, '0');
  }

  /// this method format a datetime into YYYYmmDDHHmmSS format
  /// @param dateTime - the current date time
  /// @return formattedTimeStr - formatted time
  static String getFormattedTimeYYYYmmDDHHmmSS(DateTime dateTime) {
    return getFormattedTimeYYYYmmDD(dateTime) +
        getFormattedTimeHHmmSS(dateTime);
  }

  static String convertDateToWeekDay(String date) {
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));
    DateTime dateTime = DateTime(year, month, day);
    return Constants.weekMap[dateTime.weekday]!;
  }

  static String convertHHmmToClock(String time) {
    return "${time.substring(0, 2)}:${time.substring(2, 4)}";
  }

  /// this method format a datetime into YYYY-mm-DD format
  /// @param dateTime - the current date time
  /// @return formattedTimeStr - formatted time
  static String reformatDate(String date) {
    if (date.length != 8) {
      return "Invalid date";
    }
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    return "$year-$month-$day";
  }
}
