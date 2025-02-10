// lib/widgets/chart/charts/boxplot/boxplot_chart.dart
import 'package:flutter/material.dart';
import '../../../../models/models.dart';
import 'boxplot_chart_render.dart';
import '../../../../core/utils/chart_data_processor.dart';

class BoxPlotChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const BoxPlotChartWidget({
    super.key,
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (measures.isEmpty) {
      return const Center(child: Text('箱线图需要至少一个度量'));
    }

    return CustomPaint(
      painter: BoxPlotChartRenderer(
        data: data,
        measures: measures,
        options: options,
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(),
      ),
    );
  }
}