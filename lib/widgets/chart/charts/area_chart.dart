
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../core/utils/chart_data_processor.dart';

class AreaChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const AreaChartWidget({
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
      series: measures.map((measure) => AreaSeries<ChartData, String>(
        dataSource: data,
        xValueMapper: (datum, _) => datum.dimension,
        yValueMapper: (datum, _) => datum.values[measure.name],
        name: measure.name,
        markerSettings: const MarkerSettings(isVisible: false),
        enableTooltip: true,
        legendItemText: measure.name,
        color: _getColor(measures.indexOf(measure)).withOpacity(0.3),
        borderColor: _getColor(measures.indexOf(measure)),
        borderWidth: 2,
      )).toList(),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  Color _getColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }
}
