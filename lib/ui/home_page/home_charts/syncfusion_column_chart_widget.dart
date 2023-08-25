import 'package:flutter/material.dart';
import 'package:klee/extensions/color_extensions.dart';
import 'package:klee/utils/chart_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../model/tooltip.dart';
import '../../../utils/constants.dart';
import '../../../utils/time_utils.dart';

class SyncfusionColumnChartWidget extends StatefulWidget {
  final List<double> yList;
  final List<String> timeList;
  final List<String> xList;
  final double maxY;
  final List<List<ToolTip>> toolTipsList;

  const SyncfusionColumnChartWidget(
      this.yList, this.timeList, this.xList, this.maxY, this.toolTipsList,
      {Key? key})
      : super(key: key);

  @override
  State<SyncfusionColumnChartWidget> createState() => _SyncfusionColumnChartWidgetState();
}

class _SyncfusionColumnChartWidgetState extends State<SyncfusionColumnChartWidget> {
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
        enablePanning: true,
        zoomMode: ZoomMode.x,
        enablePinching: true
    );
    _tooltipBehavior = TooltipBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        color: Colors.teal,
        header: widget.timeList[index],
        textStyle: TextStyle(color: Colors.white),
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          // Extracting the primary data
          String value = mapIntToValueString(data.y1); // Use this function to map int to string
          String time = widget.timeList[pointIndex];

          // Using logic similar to getLineTooltipItem to build the tooltip string
          String toolTipText = "Time:$time\nValue:$value";

          if (widget.toolTipsList.isNotEmpty && widget.toolTipsList[pointIndex].isNotEmpty) {
            toolTipText += "\n--------------\nUpdating:";
            for (ToolTip toolTip in widget.toolTipsList[pointIndex]) {
              String additionalText = "\n${TimeUtils.convertHHmmToClock(toolTip.time)} - ${mapIntToValueString(toolTip.val)}";
              toolTipText += additionalText;
            }

          }

          return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.green[600],
              borderRadius: BorderRadius.circular(12.0), // Adjust this value to your liking
            ),
            child: SingleChildScrollView(
              child: Text(toolTipText, style: TextStyle(color: Colors.white)),
            ),
          );
        }

    );
    super.initState();
    visibleMinimum = widget.xList.length > 6 ? widget.xList.length - 6 : 0;
    visibleMaximum = widget.xList.length.toDouble();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
          zoomPanBehavior: _zoomPanBehavior,
          primaryXAxis: CategoryAxis(
            labelStyle: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
            edgeLabelPlacement: EdgeLabelPlacement.shift, // Shift labels to the edge
            majorGridLines: MajorGridLines(width: 0),
            visibleMinimum: visibleMinimum,
            visibleMaximum: visibleMaximum,
          ),
          primaryYAxis: NumericAxis(
              maximum: widget.maxY,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              majorGridLines: MajorGridLines(width: 0),
            isVisible: false,
          ),
          series: <ChartSeries>[
            ColumnSeries<_ChartData, String>(
              dataSource: chartData,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y1,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              isTrackVisible: true,
              trackColor: Colors.indigo[50]!,
              width: 0.5,
              markerSettings: MarkerSettings(
                  isVisible: true,
                width: 5,  // Adjust these values to make the marker smaller
                height: 5,

                borderColor: Colors.blue,
                borderWidth: 2,
                color: Colors.white,
              ), // This line adds data points
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
      final x = widget.xList[i];

      if (y1 != null) {
        chartData.add(_ChartData(x, y1));
      }
    }
    return chartData;
  }

  String mapIntToValueString(double value) {
    switch (value.toInt()) {
      case 0:
        return 'Null';
      case 2:
        return 'No';
      case 4:
        return 'Mild';
      case 6:
        return 'Moderate';
      case 8:
        return 'Severe';
      default:
        return 'Unknown'; // handle any other values not in your set
    }
  }
  
}

class _ChartData {
  _ChartData(this.x, this.y1);

  final String x;
  final double y1;
}
