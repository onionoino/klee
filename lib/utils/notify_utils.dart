import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:klee/utils/time_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

/// this class is a util class related to notification affairs
class NotifyUtils {
  /// schedule notifications accordingly.
  /// @return void
  static Future<void> scheduleNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // reload here is necessary to get the updated scheduledDate value
    await prefs.reload();
    final String? lastScheduledDate =
        prefs.getString(Constants.lastScheduledDateKey);
    final String curDate = TimeUtils.getFormattedTimeYYYYmmDD(DateTime.now());
    if (lastScheduledDate == null || lastScheduledDate != curDate) {
      await prefs.setString(Constants.lastScheduledDateKey, curDate);
      await _scheduleToday();
      await _scheduleNextDays();
    } else {
      await _cancelAll();
      await _scheduleNextDays();
    }
  }

  /// cancel all notifications scheduled today
  /// @return void
  static Future<void> _cancelAll() async {
    for (int id = 1; id < 31; id++) {
      await AwesomeNotifications().cancel(id);
    }
  }

  /// schedule notifications today after Constants.notificationHour
  /// @return void
  static Future<void> _scheduleToday() async {
    DateTime now = DateTime.now();
    DateTime scheduleDateTime = DateTime.now();
    if (now.hour < Constants.notificationHour) {
      for (int hour = 0; hour < Constants.notificationHour - now.hour; hour++) {
        scheduleDateTime = scheduleDateTime.add(const Duration(hours: 1));
      }
      await _createNotification(1, scheduleDateTime);
    } else {
      await _createNotification(1, scheduleDateTime);
    }
  }

  /// schedule notification for the next days at Constants.notificationHour per day
  /// @return void
  static Future<void> _scheduleNextDays() async {
    DateTime now = DateTime.now();
    DateTime scheduleDateTime = DateTime(now.year, now.month, now.day + 1,
        Constants.notificationHour, 0, 0, 0, 0);
    for (int id = 2; id < 31; id++) {
      scheduleDateTime = scheduleDateTime.add(const Duration(days: 1));
      await _createNotification(id, scheduleDateTime);
    }
  }

  /// create notifications
  /// @return void
  static Future<void> _createNotification(int id, DateTime dateTime) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: "basic_channel",
          title: "klee Compass",
          body: "Report today ^_^",
          notificationLayout: NotificationLayout.BigText,
          fullScreenIntent: true,
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
        ),
        schedule: NotificationCalendar.fromDate(
            date: dateTime.add(const Duration(seconds: 5))));
  }
}
