// lib/widgets/chart/charts/scatter_chart.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/utils/chart_data_processor.dart';
import '../../../models/models.dart';

class ScatterChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const ScatterChartWidget({
    super.key,
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(
        title: AxisTitle(text: measures[0].name),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: measures.length > 1 ? measures[1].name : measures[0].name),
      ),
      series: <ScatterSeries<ChartData, num>>[
        ScatterSeries<ChartData, num>(
          dataSource: data,
          xValueMapper: (ChartData datum, _) => datum.values[measures[0].name],
          yValueMapper: (ChartData datum, _) => measures.length > 1
              ? datum.values[measures[1].name]
              : datum.values[measures[0].name],
          name: measures.length > 1
              ? '${measures[0].name} vs ${measures[1].name}'
              : measures[0].name,
          markerSettings: const MarkerSettings(
            height: 8,
            width: 8,
            isVisible: true,
          ),
          enableTooltip: true,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        alignment: ChartAlignment.center,
      ),
    );
  }
}