import 'package:flutter/material.dart';
import 'package:klee/extensions/color_extensions.dart';
import 'package:klee/utils/chart_utils.dart';

import '../../../model/tooltip.dart';
import '../../../utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GroupChartWidget extends StatefulWidget {
  final List<double> yList;
  final List<double> yList2;
  final List<String> timeList;
  final List<String> xList;
  final double minY;
  final List<List<ToolTip>> toolTipsList;

  const GroupChartWidget(
      this.yList, this.yList2, this.timeList, this.xList, this.minY, this.toolTipsList,
      {Key? key})
      : super(key: key);

  @override
  State<GroupChartWidget> createState() => _GroupChartWidgetState();
}

class _GroupChartWidgetState extends State<GroupChartWidget> {
  late int showingTooltip;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    showingTooltip = -1;
    int index = widget.timeList.length - 1;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      color: Colors.pink,
      header: widget.timeList[index],
      textStyle: TextStyle(color: Colors.white),
      format: 'Systolic: point.high\nDiastolic: point.low',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _getChartData();

    if (chartData.isEmpty) {
      // No data to display
      return Center(
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
          primaryXAxis: CategoryAxis(
            labelStyle: TextStyle(
              color: Colors.pink,
              fontWeight: FontWeight.bold,
            ),
            edgeLabelPlacement: EdgeLabelPlacement.shift, // Shift labels to the edge
            majorGridLines: MajorGridLines(width: 0)
          ),
          primaryYAxis: NumericAxis(
            minimum: widget.minY,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              majorGridLines: MajorGridLines(width: 0)
          ),
          series: <ChartSeries>[
            RangeColumnSeries<_ChartData, String>(
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

      if (y1 != null && y2 != null) {
        chartData.add(_ChartData(x, y1, y2));
      }
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

