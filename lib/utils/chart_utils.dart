import 'package:fl_chart/fl_chart.dart';
import 'package:securedialog/model/survey_info.dart';
import 'package:securedialog/model/tooltip.dart';
import 'package:securedialog/utils/time_utils.dart';

import '../model/chart_point.dart';
import '../model/survey_day_info.dart';
import 'base_widget.dart';
import 'constants.dart';

class ChartUtils {
  static LineTooltipItem getLineTooltipItem(List<List<ToolTip>> toolTipsList,
      int showingTooltip, String peakVal, String peakValTime, double minY) {
    String tipText = _getLineToolTipText(
        toolTipsList[showingTooltip], peakVal, peakValTime, minY);
    return BaseWidget.getLineTooltipItem(tipText);
  }

  static String _getLineToolTipText(List<ToolTip> toolTipList, String peakVal,
      String peakValTime, double minY) {
    String text = "$peakValTime - $peakVal";
    if (peakValTime == Constants.none || double.parse(peakVal) == minY) {
      text = "Null";
      return text;
    }
    if (toolTipList.isNotEmpty) {
      text = "$text\n--------------";
    }
    for (ToolTip toolTip in toolTipList) {
      String postfix =
          "\n${TimeUtils.convertHHmmToClock(toolTip.time)} - ${toolTip.val.toString()}";
      text = text + postfix;
    }
    return text;
  }

  static BarTooltipItem getBarTooltipItem(List<List<ToolTip>> toolTipsList,
      int showingTooltip, String peakVal, String peakValTime) {
    String tipText =
        _getBarToolTipText(toolTipsList[showingTooltip], peakVal, peakValTime);
    return BaseWidget.getBarTooltipItem(tipText);
  }

  static String _getBarToolTipText(
      List<ToolTip> toolTipList, String peakVal, String peakValTime) {
    String text = "$peakValTime - $peakVal";
    if (peakValTime == Constants.none) {
      text = "Null";
      return text;
    }
    if (toolTipList.isNotEmpty) {
      text = "$text\n--------------";
    }
    for (ToolTip toolTip in toolTipList) {
      String postfix =
          "\n${TimeUtils.convertHHmmToClock(toolTip.time)} - ${Constants.toolTipDoubleToStrMap[toolTip.val]}";
      text = text + postfix;
    }
    return text;
  }

  static List<ChartPoint> parseToChart(
      List<SurveyDayInfo> surveyDayInfoList, int minDayNum) {
    Map<String, List<SurveyInfo>> tempMap = {};
    for (SurveyDayInfo surveyDayInfo in surveyDayInfoList) {
      tempMap[surveyDayInfo.date] = surveyDayInfo.surveyInfoList;
    }
    List<ChartPoint> chartPointList = [];
    DateTime curDay = DateTime.now();
    for (int i = 0;
        i < minDayNum;
        i++, curDay = curDay.add(const Duration(days: -1))) {
      String requiredDate = TimeUtils.getFormattedTimeYYYYmmDD(curDay);
      if (tempMap.containsKey(requiredDate)) {
        List<SurveyInfo> curSurveyInfoList = tempMap[requiredDate]!;
        double strengthMax = Constants.optionNull;
        String strengthMaxTime = Constants.none;
        double fastingMax = Constants.fastingMinY;
        String fastingMaxTime = Constants.none;
        double postprandialMax = Constants.postprandialMinY;
        String postprandialMaxTime = Constants.none;
        double diastolicMax = Constants.diastolicMinY;
        String diastolicMaxTime = Constants.none;
        double weightMax = Constants.weightMinY;
        String weightMaxTime = Constants.none;
        double systolicMax = Constants.systolicMinY;
        String systolicMaxTime = Constants.none;
        double heartRateMax = Constants.heartRateMinY;
        String heartRateMaxTime = Constants.none;
        List<ToolTip> toolTipStrength = [];
        List<ToolTip> toolTipFasting = [];
        List<ToolTip> toolTipPostprandial = [];
        List<ToolTip> toolTipDiastolic = [];
        List<ToolTip> toolTipWeight = [];
        List<ToolTip> toolTipSystolic = [];
        List<ToolTip> toolTipHeartRate = [];
        for (SurveyInfo surveyInfo in curSurveyInfoList) {
          if (surveyInfo.strength >= strengthMax) {
            strengthMax = surveyInfo.strength;
            strengthMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.fasting >= fastingMax) {
            fastingMax = surveyInfo.fasting;
            fastingMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.postprandial >= postprandialMax) {
            postprandialMax = surveyInfo.postprandial;
            postprandialMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.diastolic >= diastolicMax) {
            diastolicMax = surveyInfo.diastolic;
            diastolicMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.weight >= weightMax) {
            weightMax = surveyInfo.weight;
            weightMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.systolic >= systolicMax) {
            systolicMax = surveyInfo.systolic;
            systolicMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.heartRate >= heartRateMax) {
            heartRateMax = surveyInfo.heartRate;
            heartRateMaxTime = surveyInfo.obTime;
          }
        }
        for (SurveyInfo surveyInfo in curSurveyInfoList) {
          if (surveyInfo.obTime != strengthMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.strength <= Constants.optionNull) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.strength;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipStrength.add(toolTip);
          }
          if (surveyInfo.obTime != fastingMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.fasting <= Constants.fastingMinY) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.fasting;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipFasting.add(toolTip);
          }
          if (surveyInfo.obTime != postprandialMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.postprandial <= Constants.postprandialMinY) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.postprandial;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipPostprandial.add(toolTip);
          }
          if (surveyInfo.obTime != diastolicMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.diastolic <= Constants.diastolicMinY) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.diastolic;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipDiastolic.add(toolTip);
          }
          if (surveyInfo.obTime != weightMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.weight <= Constants.weightMinY) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.weight;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipWeight.add(toolTip);
          }
          if (surveyInfo.obTime != systolicMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.systolic <= Constants.systolicMinY) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.systolic;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipSystolic.add(toolTip);
          }
          if (surveyInfo.obTime != heartRateMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.heartRate <= Constants.heartRateMinY) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.heartRate;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipHeartRate.add(toolTip);
          }
        }
        ChartPoint chartPoint = ChartPoint();
        chartPoint.obTimeDay = requiredDate;
        chartPoint.strengthMax = strengthMax;
        chartPoint.strengthMaxTime =
            TimeUtils.convertHHmmToClock(strengthMaxTime.substring(8, 12));
        chartPoint.fastingMax = fastingMax;
        chartPoint.fastingMaxTime =
            TimeUtils.convertHHmmToClock(fastingMaxTime.substring(8, 12));
        chartPoint.postprandialMax = postprandialMax;
        chartPoint.postprandialMaxTime =
            TimeUtils.convertHHmmToClock(postprandialMaxTime.substring(8, 12));
        chartPoint.diastolicMax = diastolicMax;
        chartPoint.diastolicMaxTime =
            TimeUtils.convertHHmmToClock(diastolicMaxTime.substring(8, 12));
        chartPoint.weightMax = weightMax;
        chartPoint.weightMaxTime =
            TimeUtils.convertHHmmToClock(weightMaxTime.substring(8, 12));
        chartPoint.systolicMax = systolicMax;
        chartPoint.systolicMaxTime =
            TimeUtils.convertHHmmToClock(systolicMaxTime.substring(8, 12));
        chartPoint.heartRateMax = heartRateMax;
        chartPoint.heartRateMaxTime =
            TimeUtils.convertHHmmToClock(heartRateMaxTime.substring(8, 12));
        chartPoint.otherStrength = toolTipStrength;
        chartPoint.otherFasting = toolTipFasting;
        chartPoint.otherPostprandial = toolTipPostprandial;
        chartPoint.otherDiastolic = toolTipDiastolic;
        chartPoint.otherWeight = toolTipWeight;
        chartPoint.otherSystolic = toolTipSystolic;
        chartPoint.otherHeartRate = toolTipHeartRate;
        chartPointList.add(chartPoint);
      } else {
        ChartPoint chartPoint = ChartPoint();
        chartPoint.obTimeDay = requiredDate;
        chartPoint.strengthMax = Constants.optionNull;
        chartPoint.strengthMaxTime = Constants.none;
        chartPoint.fastingMax = Constants.fastingMinY;
        chartPoint.fastingMaxTime = Constants.none;
        chartPoint.postprandialMax = Constants.postprandialMinY;
        chartPoint.postprandialMaxTime = Constants.none;
        chartPoint.diastolicMax = Constants.diastolicMinY;
        chartPoint.diastolicMaxTime = Constants.none;
        chartPoint.weightMax = Constants.weightMinY;
        chartPoint.weightMaxTime = Constants.none;
        chartPoint.systolicMax = Constants.systolicMinY;
        chartPoint.systolicMaxTime = Constants.none;
        chartPoint.heartRateMax = Constants.heartRateMinY;
        chartPoint.heartRateMaxTime = Constants.none;
        chartPoint.otherStrength = [];
        chartPoint.otherFasting = [];
        chartPoint.otherPostprandial = [];
        chartPoint.otherDiastolic = [];
        chartPoint.otherWeight = [];
        chartPoint.otherSystolic = [];
        chartPoint.otherHeartRate = [];
        chartPointList.add(chartPoint);
      }
    }
    chartPointList.sort((cp1, cp2) =>
        int.parse(cp1.obTimeDay).compareTo(int.parse(cp2.obTimeDay)));
    return chartPointList;
  }
}
