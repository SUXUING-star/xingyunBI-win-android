// lib/widgets/chart/charts/line_chart.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/utils/chart_data_processor.dart';
import '../../../models/models.dart';

class LineChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const LineChartWidget({
    super.key,
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
      ),
      primaryYAxis: NumericAxis(),
      series: _buildSeries(),
      legend: Legend(
        isVisible: options['legend'] ?? true,
        position: LegendPosition.bottom,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: options['tooltip'] ?? true,
      ),
    );
  }

  List<CartesianSeries> _buildSeries() {
    return measures.map((measure) {
      return LineSeries<ChartData, String>(
        dataSource: data,
        xValueMapper: (datum, _) => datum.dimension,
        yValueMapper: (datum, _) => datum.values[measure.name],
        name: measure.name,
        // Remove isVisible property
        enableTooltip: true,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: DataLabelSettings(
          isVisible: options['label'] ?? false,
        ),
        // 平滑曲线
        // 注意：SfCartesianChart 的 LineSeries 不支持 splineType
        // 如果需要平滑曲线，应该使用 SplineSeries
        //enableTooltip: true,
        // 面积图
        // Remove isVisibleInLegend as it's not needed
        color: options['area'] == true
            ? Colors.blue.withOpacity(0.1)
            : null,
      );
    }).toList();
  }
}