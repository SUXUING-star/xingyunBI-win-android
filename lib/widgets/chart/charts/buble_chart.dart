// lib/widgets/chart/charts/bubble_chart.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/utils/chart_data_processor.dart';
import '../../../models/models.dart';

class BubbleChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const BubbleChartWidget({
    super.key,
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (measures.length < 2) {
      return const Center(
        child: Text('气泡图至少需要2个度量：X轴和Y轴，可选大小和颜色'),
      );
    }

    return SfCartesianChart(
      primaryXAxis: NumericAxis(
        title: AxisTitle(text: measures[0].name),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: measures[1].name),
      ),
      series: <BubbleSeries<ChartData, num>>[
        BubbleSeries<ChartData, num>(
          dataSource: data,
          xValueMapper: (ChartData datum, _) => datum.values[measures[0].name],
          yValueMapper: (ChartData datum, _) => datum.values[measures[1].name],
          sizeValueMapper: measures.length > 2
              ? (ChartData datum, _) => datum.values[measures[2].name]
              : null,
          name: '${measures[0].name} vs ${measures[1].name}',
          color: options['color'] ?? Colors.blue,
          opacity: options['opacity'] ?? 0.7,
          minimumRadius: 5,
          maximumRadius: 25,
          pointColorMapper: measures.length > 3
              ? (ChartData datum, _) {
            final value = datum.values[measures[3].name] ?? 0;
            return _getColorFromValue(value);
          }
              : null,
          dataLabelSettings: DataLabelSettings(
            isVisible: options['label'] ?? false,
          ),
          enableTooltip: true,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  Color _getColorFromValue(num value) {
    final max = data.map((d) => d.values[measures[3].name] ?? 0).reduce((a, b) => a > b ? a : b);
    final min = data.map((d) => d.values[measures[3].name] ?? 0).reduce((a, b) => a < b ? a : b);
    final normalized = (value - min) / (max - min);
    return Color.lerp(Colors.blue, Colors.red, normalized) ?? Colors.blue;
  }
}