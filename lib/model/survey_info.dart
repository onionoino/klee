import 'package:klee/utils/constants.dart';

/// the model of survey info
class SurveyInfo {
  late double strength = Constants.optionNull;
  late double fasting = Constants.fastingMinY;
  late double postprandial = Constants.postprandialMinY;
  late double diastolic = Constants.diastolicMinY;
  late double weight = Constants.weightMinY;
  late double systolic = Constants.systolicMinY;
  late double heartRate = Constants.heartRateMinY;
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

  setWeight(String weight) {
    try {
      this.weight = double.parse(weight);
    } catch (e) {
      this.weight = Constants.weightMinY;
    }
  }

  setPostprandial(String postprandial) {
    try {
      this.postprandial = double.parse(postprandial);
    } catch (e) {
      this.postprandial = Constants.postprandialMinY;
    }
  }

  setStrength(String strength) {
    switch (strength) {
      case "No":
        this.strength = Constants.optionNo;
        break;
      case "Mild":
        this.strength = Constants.optionMild;
        break;
      case "Moderate":
        this.strength = Constants.optionModerate;
        break;
      case "Severe":
        this.strength = Constants.optionSevere;
        break;
      default:
        this.strength = Constants.optionNull;
        break;
    }
  }

  setFasting(String fasting) {
    try {
      this.fasting = double.parse(fasting);
    } catch (e) {
      this.fasting = Constants.fastingMinY;
    }
  }

  setObTime(String obTime) {
    this.obTime = obTime;
  }
}
