import 'package:klee/utils/constants.dart';

/// the model of survey info
class SurveyInfo {
  late double isCough = Constants.optionNull;
  late double isSoreThroat = Constants.optionNull;
  late double temperature = Constants.temperatureMinY;
  late double diastolic = Constants.diastolicMinY;
  late double heartRate = Constants.heartRateMinY;
  late double systolic = Constants.systolicMinY;
  late String obTime = Constants.defaultObTime;

  setDiastolic(String diastolic) {
    try {
      this.diastolic = double.parse(diastolic);
    } catch (e) {
      this.diastolic = Constants.diastolicMinY;
    }
  }

  setSystolic(String systolic) {
    try {
      this.systolic = double.parse(systolic);
    } catch (e) {
      this.systolic = Constants.systolicMinY;
    }
  }

  setHeartRate(String heartRate) {
    try {
      this.heartRate = double.parse(heartRate);
    } catch (e) {
      this.heartRate = Constants.heartRateMinY;
    }
  }

  setTemperature(String temperature) {
    try {
      this.temperature = double.parse(temperature);
    } catch (e) {
      this.temperature = Constants.temperatureMinY;
    }
  }

  setIsCough(String isCough) {
    switch (isCough) {
      case "No":
        this.isCough = Constants.optionNo;
        break;
      case "Mild":
        this.isCough = Constants.optionMild;
        break;
      case "Moderate":
        this.isCough = Constants.optionModerate;
        break;
      case "Severe":
        this.isCough = Constants.optionSevere;
        break;
      default:
        this.isCough = Constants.optionNull;
        break;
    }
  }

  setIsSoreThroat(String isSoreThroat) {
    switch (isSoreThroat) {
      case "No":
        this.isSoreThroat = Constants.optionNo;
        break;
      case "Mild":
        this.isSoreThroat = Constants.optionMild;
        break;
      case "Moderate":
        this.isSoreThroat = Constants.optionModerate;
        break;
      case "Severe":
        this.isSoreThroat = Constants.optionSevere;
        break;
      default:
        this.isSoreThroat = Constants.optionNull;
        break;
    }
  }

  setObTime(String obTime) {
    this.obTime = obTime;
  }
}
