import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:klee/extensions/color_extensions.dart';

import '../../../utils/constants.dart';

class BarChartWidget extends StatefulWidget {
  final List<double> yList;
  final List<String> xList;
  final double maxY;

  const BarChartWidget(this.yList, this.xList, this.maxY, {Key? key})
      : super(key: key);

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
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
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            if (rod.toY == Constants.optionNo) {
              return BarTooltipItem(
                "( ᕑᗢᓫ )",
                const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else if (rod.toY == Constants.optionMild) {
              return BarTooltipItem(
                "(>﹏<)",
                const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else if (rod.toY == Constants.optionYes) {
              return BarTooltipItem(
                "( ºΔº )",
                const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              return BarTooltipItem(
                "Null",
                const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          },
        ),
      );

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
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: widget.yList[1],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: widget.yList[2],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: widget.yList[3],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: widget.yList[4],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: widget.yList[5],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: widget.yList[6],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}
