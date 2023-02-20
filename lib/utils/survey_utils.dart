import 'constants.dart';

/// this class is a util class related to survey affairs
class SurveyUtils {
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
  ///        dateTime - the timestamp collected when submitting the survey
  /// @return surveyMap - K-V structure to make further process more convenient
  static Map<String, String> getFormattedSurvey(
      String answer1,
      String answer2,
      String answer3,
      String answer4,
      String answer5,
      String answer6,
      DateTime dateTime) {
    return <String, String>{
      Constants.q1: answer1,
      Constants.q2: answer2,
      Constants.q3: answer3,
      Constants.q4: answer4,
      Constants.q5: answer5,
      Constants.q6: answer6,
      Constants.lastFinishTime: getFormattedLastFinishTime(dateTime),
    };
  }

  /// format a timestamp into a lastFinishTime format
  /// @param dateTime - the timestamp
  /// @return formattedTime - a formatted time used in lastFinishTime related logics
  static String getFormattedLastFinishTime(DateTime dateTime) {
    return dateTime.toString().substring(0, 10);
  }
}
