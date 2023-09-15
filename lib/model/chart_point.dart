/// Provide the model of ChartPoint
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

import 'package:securedialog/model/tooltip.dart';

class ChartPoint {
  late double strengthMax;
  late String strengthMaxTime;
  late List<ToolTip> otherStrength;
  late double fastingMax;
  late String fastingMaxTime;
  late List<ToolTip> otherFasting;
  late double postprandialMax;
  late String postprandialMaxTime;
  late List<ToolTip> otherPostprandial;
  late double diastolicMax;
  late String diastolicMaxTime;
  late List<ToolTip> otherDiastolic;
  late double weightMax;
  late String weightMaxTime;
  late List<ToolTip> otherWeight;
  late double systolicMax;
  late String systolicMaxTime;
  late List<ToolTip> otherSystolic;
  late double heartRateMax;
  late String heartRateMaxTime;
  late List<ToolTip> otherHeartRate;
  late String obTimeDay;
}
