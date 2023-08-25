import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:klee/utils/chart_utils.dart';

import '../../../model/tooltip.dart';
import '../../../utils/constants.dart';

class LineChartWidget extends StatefulWidget {
  final List<double> yList;
  final List<String> timeList;
  final List<String> xList;
  final double minY;
  final List<List<ToolTip>> toolTipsList;

  const LineChartWidget(
      this.yList, this.timeList, this.xList, this.minY, this.toolTipsList,
      {Key? key})
      : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final Color gradientColor1 = Colors.blue;
  final Color gradientColor2 = Colors.pink;
  final Color gradientColor3 = Colors.red;
  final Color indicatorStrokeColor = Colors.black;

  // List<int> get showIndexes => const [6];
  // Update the showIndexes list to include the indices of the spots
  List<int> get showIndexes => List.generate(Constants.lineNumber, (index) => index);

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.pink,
      fontFamily: 'Digital',
      fontSize: 18 * chartWidth / 500,
    );
    String text;
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
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> allSpots = [];
    for (int i = 0; i < Constants.lineNumber; i++) {
      allSpots.add(FlSpot(i.toDouble(), widget.yList[i]));
    }

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showIndexes,
        spots: allSpots,
        isCurved: true,
        barWidth: 4,
        shadow: const Shadow(
          blurRadius: 8,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              gradientColor1.withOpacity(0.4),
              gradientColor2.withOpacity(0.4),
              gradientColor3.withOpacity(0.4),
            ],
          ),
        ),
        dotData: FlDotData(show: true),
        gradient: LinearGradient(
          colors: [
            gradientColor1,
            gradientColor2,
            gradientColor3,
          ],
          stops: const [0.1, 0.4, 0.9],
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 10,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return LineChart(
            LineChartData(
              showingTooltipIndicators: showIndexes.map((index) {
                return ShowingTooltipIndicators([
                  LineBarSpot(
                    tooltipsOnBar,
                    lineBarsData.indexOf(tooltipsOnBar),
                    tooltipsOnBar.spots[index],
                  ),
                ]);
              }).toList(),
              lineTouchData: LineTouchData(
                enabled: true,
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: Colors.pink,
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 8,
                          color: _lerpGradient(
                            barData.gradient!.colors,
                            barData.gradient!.stops!,
                            percent / 100,
                          ),
                          strokeWidth: 2,
                          strokeColor: indicatorStrokeColor,
                        ),
                      ),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.pink,
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.all(2),
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      int showingTooltip = lineBarSpot.x.toInt();
                      return ChartUtils.getLineTooltipItem(
                          widget.toolTipsList,
                          showingTooltip,
                          lineBarSpot.y.toString(),
                          widget.timeList[showingTooltip],
                          widget.minY);
                    }).toList();
                  },
                ),
              ),
              lineBarsData: lineBarsData,
              minY: widget.minY,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: const Text(''),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return bottomTitleWidgets(
                        value,
                        meta,
                        constraints.maxWidth,
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                rightTitles: AxisTitles(
                  axisNameWidget: const Text(''),
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

Color _lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];
    final leftColor = colors[s];
    final rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
