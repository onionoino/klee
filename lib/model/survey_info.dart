import 'package:klee/utils/constants.dart';

class SurveyInfo {
  late double isCough;
  late double isSoreThroat;
  late double temperature;
  late double diastolic;
  late double heartRate;
  late double systolic;
  late String obTime;

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
      case "Yes":
        this.isCough = Constants.optionYes;
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
      case "Yes":
        this.isSoreThroat = Constants.optionYes;
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
