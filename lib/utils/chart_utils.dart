import 'package:fl_chart/fl_chart.dart';
import 'package:klee/model/survey_info.dart';
import 'package:klee/model/tooltip.dart';
import 'package:klee/utils/time_utils.dart';

import '../model/chart_point.dart';
import '../model/survey_day_info.dart';
import 'base_widget.dart';
import 'constants.dart';

class ChartUtils {
  static LineTooltipItem getLineTooltipItem(
      List<List<ToolTip>> toolTipsList, int showingTooltip, String peakVal, String peakValTime, double minY) {
    String tipText = _getLineToolTipText(toolTipsList[showingTooltip], peakVal, peakValTime, minY);
    return BaseWidget.getLineTooltipItem(tipText);
  }

  static String _getLineToolTipText(List<ToolTip> toolTipList, String peakVal, String peakValTime, double minY) {
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

  static BarTooltipItem getBarTooltipItem(
      List<List<ToolTip>> toolTipsList, int showingTooltip, String peakVal, String peakValTime) {
    String tipText = _getBarToolTipText(toolTipsList[showingTooltip], peakVal, peakValTime);
    return BaseWidget.getBarTooltipItem(tipText);
  }

  static String _getBarToolTipText(List<ToolTip> toolTipList, String peakVal, String peakValTime) {
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
        double isCoughMax = Constants.optionNull;
        String isCoughMaxTime = Constants.none;
        double isSoreThroatMax = Constants.optionNull;
        String isSoreThroatMaxTime = Constants.none;
        double temperatureMax = Constants.temperatureMinY;
        String temperatureMaxTime = Constants.none;
        double diastolicMax = Constants.diastolicMinY;
        String diastolicMaxTime = Constants.none;
        double heartRateMax = Constants.heartRateMinY;
        String heartRateMaxTime = Constants.none;
        double systolicMax = Constants.systolicMinY;
        String systolicMaxTime = Constants.none;
        List<ToolTip> toolTipIsCough = [];
        List<ToolTip> toolTipIsSoreThroat = [];
        List<ToolTip> toolTipTemperature = [];
        List<ToolTip> toolTipDiastolic = [];
        List<ToolTip> toolTipHeartRate = [];
        List<ToolTip> toolTipSystolic = [];
        for (SurveyInfo surveyInfo in curSurveyInfoList) {
          if (surveyInfo.isCough >= isCoughMax) {
            isCoughMax = surveyInfo.isCough;
            isCoughMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.isSoreThroat >= isSoreThroatMax) {
            isSoreThroatMax = surveyInfo.isSoreThroat;
            isSoreThroatMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.temperature >= temperatureMax) {
            temperatureMax = surveyInfo.temperature;
            temperatureMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.diastolic >= diastolicMax) {
            diastolicMax = surveyInfo.diastolic;
            diastolicMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.heartRate >= heartRateMax) {
            heartRateMax = surveyInfo.heartRate;
            heartRateMaxTime = surveyInfo.obTime;
          }
          if (surveyInfo.systolic >= systolicMax) {
            systolicMax = surveyInfo.systolic;
            systolicMaxTime = surveyInfo.obTime;
          }
        }
        for (SurveyInfo surveyInfo in curSurveyInfoList) {
          if (surveyInfo.obTime != isCoughMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.isCough <= Constants.optionNull) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.isCough;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipIsCough.add(toolTip);
          }
          if (surveyInfo.obTime != isSoreThroatMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.isSoreThroat <= Constants.optionNull) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.isSoreThroat;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipIsSoreThroat.add(toolTip);
          }
          if (surveyInfo.obTime != temperatureMaxTime) {
            ToolTip toolTip = ToolTip();
            if (surveyInfo.temperature <= Constants.temperatureMinY) {
              toolTip.val = Constants.toolTipNoneVal;
            } else {
              toolTip.val = surveyInfo.temperature;
            }
            toolTip.time = surveyInfo.obTime.substring(8, 12);
            toolTipTemperature.add(toolTip);
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
        }
        ChartPoint chartPoint = ChartPoint();
        chartPoint.obTimeDay = requiredDate;
        chartPoint.isCoughMax = isCoughMax;
        chartPoint.isCoughMaxTime = TimeUtils.convertHHmmToClock(isCoughMaxTime.substring(8, 12));
        chartPoint.isSoreThroatMax = isSoreThroatMax;
        chartPoint.isSoreThroatMaxTime = TimeUtils.convertHHmmToClock(isSoreThroatMaxTime.substring(8, 12));
        chartPoint.temperatureMax = temperatureMax;
        chartPoint.temperatureMaxTime = TimeUtils.convertHHmmToClock(temperatureMaxTime.substring(8, 12));
        chartPoint.diastolicMax = diastolicMax;
        chartPoint.diastolicMaxTime = TimeUtils.convertHHmmToClock(diastolicMaxTime.substring(8, 12));
        chartPoint.heartRateMax = heartRateMax;
        chartPoint.heartRateMaxTime = TimeUtils.convertHHmmToClock(heartRateMaxTime.substring(8, 12));
        chartPoint.systolicMax = systolicMax;
        chartPoint.systolicMaxTime = TimeUtils.convertHHmmToClock(systolicMaxTime.substring(8, 12));
        chartPoint.otherIsCough = toolTipIsCough;
        chartPoint.otherIsSoreThroat = toolTipIsSoreThroat;
        chartPoint.otherTemperature = toolTipTemperature;
        chartPoint.otherDiastolic = toolTipDiastolic;
        chartPoint.otherHeartRate = toolTipHeartRate;
        chartPoint.otherSystolic = toolTipSystolic;
        chartPointList.add(chartPoint);
      } else {
        ChartPoint chartPoint = ChartPoint();
        chartPoint.obTimeDay = requiredDate;
        chartPoint.isCoughMax = Constants.optionNull;
        chartPoint.isCoughMaxTime = Constants.none;
        chartPoint.isSoreThroatMax = Constants.optionNull;
        chartPoint.isSoreThroatMaxTime = Constants.none;
        chartPoint.temperatureMax = Constants.temperatureMinY;
        chartPoint.temperatureMaxTime = Constants.none;
        chartPoint.diastolicMax = Constants.diastolicMinY;
        chartPoint.diastolicMaxTime = Constants.none;
        chartPoint.heartRateMax = Constants.heartRateMinY;
        chartPoint.heartRateMaxTime = Constants.none;
        chartPoint.systolicMax = Constants.systolicMinY;
        chartPoint.systolicMaxTime = Constants.none;
        chartPoint.otherIsCough = [];
        chartPoint.otherIsSoreThroat = [];
        chartPoint.otherTemperature = [];
        chartPoint.otherDiastolic = [];
        chartPoint.otherHeartRate = [];
        chartPoint.otherSystolic = [];
        chartPointList.add(chartPoint);
      }
    }
    chartPointList.sort((cp1, cp2) =>
        int.parse(cp1.obTimeDay).compareTo(int.parse(cp2.obTimeDay)));
    return chartPointList;
  }
}
