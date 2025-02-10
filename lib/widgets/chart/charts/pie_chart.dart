// lib/widgets/chart/charts/pie_chart.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/utils/chart_data_processor.dart';
import '../../../models/models.dart';

class PieChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const PieChartWidget({
    super.key,
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (measures.isEmpty) return const SizedBox();

    final measure = measures.first; // 饼图只使用第一个度量

    return SfCircularChart(
      series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (datum, _) => datum.dimension,
          yValueMapper: (datum, _) => datum.values[measure.name],
          dataLabelSettings: DataLabelSettings(
            isVisible: options['label'] ?? true,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings: const ConnectorLineSettings(
              type: ConnectorType.curve,
              length: '15%',
            ),
          ),
          enableTooltip: true,
          // 南丁格尔玫瑰图
          pointRadiusMapper: options['roseType'] == true
              ? (datum, _) => datum.values[measure.name].toString()
              : null,
        ),
      ],
      legend: Legend(
        isVisible: options['legend'] ?? true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: options['tooltip'] ?? true,
      ),
    );
  }
}