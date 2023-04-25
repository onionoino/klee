import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:klee/extensions/color_extensions.dart';
import 'package:klee/utils/chart_utils.dart';

import '../../../model/tooltip.dart';
import '../../../utils/constants.dart';

class BarChartWidget extends StatefulWidget {
  final List<double> yList;
  final List<String> timeList;
  final List<String> xList;
  final double maxY;
  final List<List<ToolTip>> toolTipsList;

  const BarChartWidget(this.yList, this.timeList, this.xList, this.maxY, this.toolTipsList, {Key? key})
      : super(key: key);

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: widget.maxY,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
      enabled: true,
      handleBuiltInTouches: false,
      touchCallback: (event, response) {
        if (response != null &&
            response.spot != null &&
            event is FlTapUpEvent) {
          setState(() {
            final x = response.spot!.touchedBarGroup.x;
            final isShowing = showingTooltip == x;
            if (isShowing) {
              showingTooltip = -1;
            } else {
              showingTooltip = x;
            }
          });
        }
      },
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.black54,
        tooltipPadding: const EdgeInsets.all(2),
        tooltipMargin: 5,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          if (rod.toY == Constants.optionNo) {
            return ChartUtils.getBarTooltipItem(widget.toolTipsList, showingTooltip, "No", widget.timeList[showingTooltip]);
          } else if (rod.toY == Constants.optionMild) {
            return ChartUtils.getBarTooltipItem(widget.toolTipsList, showingTooltip, "Mild", widget.timeList[showingTooltip]);
          } else if (rod.toY == Constants.optionModerate) {
            return ChartUtils.getBarTooltipItem(widget.toolTipsList, showingTooltip, "Mod", widget.timeList[showingTooltip]);
          } else if (rod.toY == Constants.optionSevere) {
            return ChartUtils.getBarTooltipItem(widget.toolTipsList, showingTooltip, "Sev", widget.timeList[showingTooltip]);
          } else {
            return ChartUtils.getBarTooltipItem(widget.toolTipsList, showingTooltip, "Null", widget.timeList[showingTooltip]);
          }
        },
      ),
      mouseCursorResolver: (event, response) {
        return response == null || response.spot == null
            ? MouseCursor.defer
            : SystemMouseCursors.click;
      });

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue.darken(20),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = "";
    switch (value.toInt()) {
      case 0:
        text = widget.xList[0];
        break;
      case 1:
        text = widget.xList[1];
        break;
      case 2:
        text = widget.xList[2];
        break;
      case 3:
        text = widget.xList[3];
        break;
      case 4:
        text = widget.xList[4];
        break;
      case 5:
        text = widget.xList[5];
        break;
      case 6:
        text = widget.xList[6];
        break;
      default:
        text = Constants.defaultObTime;
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.blue.darken(20),
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: widget.yList[0],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: showingTooltip == 0 ? [0] : [],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: widget.yList[1],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: showingTooltip == 1 ? [0] : [],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: widget.yList[2],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: showingTooltip == 2 ? [0] : [],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: widget.yList[3],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: showingTooltip == 3 ? [0] : [],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: widget.yList[4],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: showingTooltip == 4 ? [0] : [],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: widget.yList[5],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: showingTooltip == 5 ? [0] : [],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: widget.yList[6],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: showingTooltip == 6 ? [0] : [],
        ),
      ];
}
