// lib/widgets/chart/charts/bar_chart.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/utils/chart_data_processor.dart';
import '../../../models/models.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const BarChartWidget({
    super.key,
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    final isStack = options['stack'] ?? false;
    final isHorizontal = options['direction'] == 'horizontal';

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        isVisible: true,
        labelRotation: isHorizontal ? 0 : 45,
      ),
      primaryYAxis: NumericAxis(
        isVisible: true,
      ),
      series: _buildSeries(isHorizontal, isStack),
      legend: Legend(
        isVisible: options['legend'] ?? true,
        position: LegendPosition.bottom,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: options['tooltip'] ?? true,
      ),
    );
  }

  List<CartesianSeries> _buildSeries(bool isHorizontal, bool isStack) {
    return measures.map((measure) {
      if (isHorizontal) {
        return BarSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (datum, _) => datum.dimension,
          yValueMapper: (datum, _) => datum.values[measure.name],
          name: measure.name,
          // Remove isVisible property as it's not needed
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: options['label'] ?? false,
          ),
        );
      } else {
        return ColumnSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (datum, _) => datum.dimension,
          yValueMapper: (datum, _) => datum.values[measure.name],
          name: measure.name,
          // Remove isVisible property as it's not needed
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: options['label'] ?? false,
          ),
        );
      }
    }).toList();
  }
}