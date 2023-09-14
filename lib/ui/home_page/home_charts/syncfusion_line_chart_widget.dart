import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../model/tooltip.dart';
import '../../../utils/constants.dart';
import '../../../utils/time_utils.dart';

class SyncfusionLineChartWidget extends StatefulWidget {
  final List<double> yList;
  final List<String> timeList;
  final List<String> xList;
  final double minY;
  final List<List<ToolTip>> toolTipsList;

  const SyncfusionLineChartWidget(
      this.yList, this.timeList, this.xList, this.minY, this.toolTipsList,
      {Key? key})
      : super(key: key);

  @override
  State<SyncfusionLineChartWidget> createState() => _SyncfusionLineChartWidgetState();
}

class _SyncfusionLineChartWidgetState extends State<SyncfusionLineChartWidget> {
  late int showingTooltip;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  late double visibleMinimum;
  late double visibleMaximum;

  @override
  void initState() {
    showingTooltip = -1;
    int index = widget.timeList.length - 1;

    _tooltipBehavior = TooltipBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        color: Colors.teal,
        header: widget.timeList[index],
        textStyle: const TextStyle(color: Colors.white),
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          // If timeList is null or empty, don't show the tooltip
          if (widget.yList[pointIndex] == 0) {
            return const SizedBox.shrink();
          } else{
            // Extracting the primary data
            String show = widget.yList[pointIndex].toString();
            String time = widget.timeList[pointIndex];

            // Using logic similar to getLineTooltipItem to build the tooltip string
            String toolTipText = "Time:$time\nValue:$show";

            if (widget.toolTipsList.isNotEmpty && widget.toolTipsList[pointIndex].isNotEmpty) {
              toolTipText += "\n--------------\nUpdating:";
              for (ToolTip toolTip in widget.toolTipsList[pointIndex]) {
                String additionalText = "\n${TimeUtils.convertHHmmToClock(toolTip.time)} - ${toolTip.val.toString()}";
                toolTipText += additionalText;
              }

            }
            return Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(12.0), // Adjust this value to your liking
              ),
              child: SingleChildScrollView(
                child: Text(toolTipText, style: const TextStyle(color: Colors.white)),
              ),
            );
          }
        }

    );
    _zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true,
        zoomMode: ZoomMode.x,
        enablePinching: true
    );
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
            edgeLabelPlacement: EdgeLabelPlacement.shift, // Shift labels to the edge
            majorGridLines: const MajorGridLines(width: 0),
            visibleMinimum: visibleMinimum,
            visibleMaximum: visibleMaximum,
            // visibleMinimum: 7,
            // visibleMaximum: widget.xList.length.toDouble(),
          ),
          primaryYAxis: NumericAxis(
              minimum: widget.minY,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              majorGridLines: const MajorGridLines(width: 0)
          ),
          series: <ChartSeries>[
            SplineSeries<_ChartData, String>(
              dataSource: chartData,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y1,
              width: 3.5,
              markerSettings: const MarkerSettings(
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

      chartData.add(_ChartData(x, y1));
    }
    return chartData;
  }
}

class _ChartData {
  _ChartData(this.x, this.y1);

  final String x;
  final double y1;
}
