import 'constants.dart';

/// this class is a util class related to survey affairs
class SurveyUtils {
  /// check if a string complies body temperature format,
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
    }catch (e) {
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
  static Map<String, String> getFormattedSurvey(String answer1, String answer2, String answer3, DateTime dateTime) {
    return <String, String>{
      Constants.q1: answer1,
      Constants.q2: answer2,
      Constants.q3: answer3,
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