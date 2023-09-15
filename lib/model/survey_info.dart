/// Provide the model of survey information
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
/// Authors: Bowen Yang, Ye Duan

import 'package:securedialog/utils/constants.dart';

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
