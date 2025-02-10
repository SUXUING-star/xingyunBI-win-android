// lib/widgets/chart/charts/heatmap_chart.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/utils/chart_data_processor.dart';
import '../../../models/models.dart';

class HeatmapChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const HeatmapChartWidget({
    super.key,
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (measures.length < 1) {
      return const Center(child: Text('热力图需要至少一个度量'));
    }

    // 转换数据为热力图格式
    final List<List<double>> heatmapData = _processDataForHeatmap();

    return SizedBox(
      width: double.infinity,
      height: 400,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          childAspectRatio: 1,
        ),
        itemCount: heatmapData.length * heatmapData[0].length,
        itemBuilder: (context, index) {
          final row = index ~/ heatmapData[0].length;
          final col = index % heatmapData[0].length;
          final value = heatmapData[row][col];
          final normalized = (value - _getMinValue(measures[0].name)) /
              (_getMaxValue(measures[0].name) - _getMinValue(measures[0].name));

          return Container(
            margin: const EdgeInsets.all(1),
            color: Color.lerp(Colors.blue[50], Colors.blue[900], normalized),
            child: options['label'] == true
                ? Center(child: Text(value.toStringAsFixed(1)))
                : null,
          );
        },
      ),
    );
  }

  List<List<double>> _processDataForHeatmap() {
    final result = <List<double>>[];
    final dimensions = data.map((d) => d.dimension).toSet().toList();

    for (var measure in measures) {
      final List<double> row = [];
      for (var dimension in dimensions) {
        final value = data
            .firstWhere((d) => d.dimension == dimension)
            .values[measure.name] ?? 0;
        row.add(value.toDouble());
      }
      result.add(row);
    }

    return result;
  }

  num _getMinValue(String field) {
    return data.map((d) => d.values[field] ?? 0).reduce((a, b) => a < b ? a : b);
  }

  num _getMaxValue(String field) {
    return data.map((d) => d.values[field] ?? 0).reduce((a, b) => a > b ? a : b);
  }
}