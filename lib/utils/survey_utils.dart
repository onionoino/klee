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

  static Map<String, String> getFormattedSurvey(String answer1, String answer2, String answer3, DateTime dateTime) {
    return <String, String>{
      Constants.q1: answer1,
      Constants.q2: answer2,
      Constants.q3: answer3,
      Constants.lastFinishTime: _getFormattedLastFinishTime(dateTime),
    };
  }

  static String _getFormattedLastFinishTime(DateTime dateTime) {
    return dateTime.toString().substring(0, 10);
  }
}