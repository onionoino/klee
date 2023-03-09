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

  /// this method format a datetime into clock HHmm format
  /// @param dateTime - the current date time
  /// @return formattedTimeStr - formatted time
  static String getFormattedTimeClockHHmm(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
