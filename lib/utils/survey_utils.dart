import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

/// this class is a util class related to survey affairs
class SurveyUtils {
  /// get last survey time to decide whether pop up a reminder to user when they click Q&A tab
  /// @param authData - the authentication data get from login procedure
  /// @return lastSurveyTime - user's last survey time
  static Future<String?> getLastSurveyTime(
      Map<dynamic, dynamic>? authData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("lastSurveyDate");
  }

  /// check if a string complies with body temperature format,
  /// a body temperature format is XX.X and it should <= 42.0 && >= 35.0
  /// @param temperatureText - a string text of body temperature
  /// @return isValid - TRUE means it valid, FALSE means not
  static bool checkBodyTemperatureText(String temperatureText) {
    double temperature;
    if (!temperatureText.contains(".")) {
      return false;
    }
    try {
      temperature = double.parse(temperatureText);
      if (temperature < 35.0 || temperature > 42.0) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  /// check if a string complies with systolic format,
  /// a systolic format is a 2 or 3-digits integer and it should <= 220 && >= 50
  /// @param systolicText - a string text of systolic
  /// @return isValid - TRUE means it valid, FALSE means not
  static bool checkSystolicText(String systolicText) {
    int systolic;
    try {
      systolic = int.parse(systolicText);
      if (systolic < 50 || systolic > 220) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  /// check if a string complies with diastolic format,
  /// a diastolic format is a 2 or 3-digits integer and it should <= 160 && >= 30
  /// @param diastolicText - a string text of diastolic
  /// @return isValid - TRUE means it valid, FALSE means not
  static bool checkDiastolicText(String diastolicText) {
    int diastolic;
    try {
      diastolic = int.parse(diastolicText);
      if (diastolic < 30 || diastolic > 160) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  /// check if a string complies with heart rate format,
  /// a heart rate format is a 2 or 3-digits integer and it should <= 160 && >= 40
  /// @param heartRateText - a string text of heart rate
  /// @return isValid - TRUE means it valid, FALSE means not
  static bool checkHeartRateText(String heartRateText) {
    int heartRate;
    try {
      heartRate = int.parse(heartRateText);
      if (heartRate < 40 || heartRate > 160) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  /// get a map of formatted survey information for further processing
  /// @param answer1 - q1's answer
  ///        answer2 - q2's answer
  ///        answer3 - q3's answer
  ///        answer4 - q4's answer
  ///        answer5 - q5's answer
  ///        answer6 - q6's answer
  /// @return surveyMap - K-V structure to make further process more convenient
  static Map<String, String> getFormattedSurvey(String answer1, String answer2,
      String answer3, String answer4, String answer5, String answer6) {
    return <String, String>{
      Constants.q1Key: answer1,
      Constants.q2Key: answer2,
      Constants.q3Key: answer3,
      Constants.q4Key: answer4,
      Constants.q5Key: answer5,
      Constants.q6Key: answer6,
    };
  }
}
