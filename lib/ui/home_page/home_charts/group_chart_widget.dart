/// The widget for displaying a grouped chart
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
/// Authors: Ye Duan

import 'package:flutter/material.dart';
import 'package:securedialog/extensions/color_extensions.dart';

import '../../../model/tooltip.dart';
import '../../../utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/time_utils.dart';

class GroupChartWidget extends StatefulWidget {
  final List<double> yList;
  final List<double> yList2;
  final List<String> timeList;
  final List<String> xList;
  final double minY;
  final List<List<ToolTip>> toolTipsList;
  final List<List<ToolTip>> toolTipsList2;

  const GroupChartWidget(this.yList, this.yList2, this.timeList, this.xList,
      this.minY, this.toolTipsList, this.toolTipsList2,
      {Key? key})
      : super(key: key);

  @override
  State<GroupChartWidget> createState() => _GroupChartWidgetState();
}

class _GroupChartWidgetState extends State<GroupChartWidget> {
  late int showingTooltip;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  late double visibleMinimum;
  late double visibleMaximum;

  @override
  void initState() {
    showingTooltip = -1;
    int index = widget.timeList.length - 1;
    _zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true, zoomMode: ZoomMode.x, enablePinching: true);
    _tooltipBehavior = TooltipBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        color: Colors.teal,
        header: widget.timeList[index],
        textStyle: const TextStyle(color: Colors.white),
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          // Extracting the primary data
          String showSystolic = widget.yList[pointIndex].toString();
          String showDiastolic = widget.yList2[pointIndex].toString();
          String time = widget.timeList[pointIndex];

          // Using logic similar to getLineTooltipItem to build the tooltip string
          String toolTipText =
              "$time\nSystolic: $showSystolic\nDiastolic: $showDiastolic";

          if (widget.toolTipsList.isNotEmpty &&
              widget.toolTipsList[pointIndex].isNotEmpty) {
            toolTipText += "\n--------------\nSystolic updating:";
            for (ToolTip toolTip in widget.toolTipsList[pointIndex]) {
              String additionalText =
                  "\n${TimeUtils.convertHHmmToClock(toolTip.time)} - ${toolTip.val.toString()}";
              toolTipText += additionalText;
            }
          }

          if (widget.toolTipsList2.isNotEmpty &&
              widget.toolTipsList2[pointIndex].isNotEmpty) {
            toolTipText += "\n--------------\nDiastolic updating:";
            for (ToolTip toolTip in widget.toolTipsList2[pointIndex]) {
              String additionalText =
                  "\n${TimeUtils.convertHHmmToClock(toolTip.time)} - ${toolTip.val.toString()}";
              toolTipText += additionalText;
            }
          }

          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.green[600],
              borderRadius: BorderRadius.circular(
                  12.0), // Adjust this value to your liking
            ),
            child: SingleChildScrollView(
              child: Text(toolTipText,
                  style: const TextStyle(color: Colors.white)),
            ),
          );
        });
    super.initState();
    visibleMinimum = widget.xList.length > 6 ? widget.xList.length - 6 : 0;
    visibleMaximum = widget.xList.length.toDouble();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Update your state variables here
        visibleMinimum = 7.0; // New minimum value
        visibleMaximum = 15.0; // New maximum value
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _getChartData();

    if (chartData.isEmpty) {
      // No data to display
      return const Center(
        child: Text('No data available.'),
      );
    }

    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 10,
        ),
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          zoomPanBehavior: _zoomPanBehavior,
          primaryXAxis: CategoryAxis(
            labelStyle: const TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
            edgeLabelPlacement:
                EdgeLabelPlacement.shift, // Shift labels to the edge
            majorGridLines: const MajorGridLines(width: 0),
            visibleMinimum: visibleMinimum,
            visibleMaximum: visibleMaximum,
          ),
          primaryYAxis: NumericAxis(
              minimum: widget.minY,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              majorGridLines: const MajorGridLines(width: 0)),
          series: <ChartSeries>[
            RangeColumnSeries<_ChartData, String>(
              width: 0.3,
              enableTooltip: true,
              dataSource: chartData,
              xValueMapper: (_ChartData data, _) => data.x,
              lowValueMapper: (_ChartData data, _) => data.y1,
              highValueMapper: (_ChartData data, _) => data.y2,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.darken(20),
                  Colors.cyan,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      ),
    );
  }

  List<_ChartData> _getChartData() {
    final List<_ChartData> chartData = [];

    for (int i = 0; i < Constants.lineNumber; i++) {
      final y1 = widget.yList[i];
      final y2 = widget.yList2[i];
      final x = widget.xList[i];

      chartData.add(_ChartData(x, y1, y2));
    }
    return chartData;
  }
}

class _ChartData {
  _ChartData(this.x, this.y1, this.y2);

  final String x;
  final double y1;
  final double y2;
}
