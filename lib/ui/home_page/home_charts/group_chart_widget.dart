import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:klee/extensions/color_extensions.dart';
import 'package:klee/utils/chart_utils.dart';

import '../../../model/tooltip.dart';
import '../../../utils/constants.dart';

class GroupChartWidget extends StatefulWidget {
  final List<double> yList;
  final List<String> timeList;
  final List<String> xList;
  final double minY;
  final List<List<ToolTip>> toolTipsList;

  const GroupChartWidget(
      this.yList, this.timeList, this.xList, this.minY, this.toolTipsList,
      {Key? key})
      : super(key: key);

  @override
  State<GroupChartWidget> createState() => _GroupChartWidgetState();
}

class _GroupChartWidgetState extends State<GroupChartWidget> {
  final Color gradientColor1 = Colors.blue;
  final Color gradientColor2 = Colors.pink;
  final Color gradientColor3 = Colors.red;
  final Color indicatorStrokeColor = Colors.black;


  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

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
    final barChartGroups = List<BarChartGroupData>.generate(
      Constants.lineNumber,
          (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: widget.yList[index],
            gradient: LinearGradient(
              colors: [
                gradientColor1,
                gradientColor2,
                gradientColor3
              ],
              stops: const [0.1, 0.4, 0.9],
            ),
          )
        ],
        showingTooltipIndicators: [0],
      ),
    );


    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 10,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              barGroups: barChartGroups,
              gridData: FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              minY: widget.minY,
            ),
          );
        }),
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
      tooltipBgColor: Colors.pink,
      tooltipPadding: const EdgeInsets.all(2),
      tooltipMargin: 5,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return ChartUtils.getBarTooltipItem(widget.toolTipsList, showingTooltip, rod.toY.toString(), widget.timeList[showingTooltip]);
        // return BarTooltipItem(rod.toY.toString(), TextStyle(color: Colors.white));
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
}