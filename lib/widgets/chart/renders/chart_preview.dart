// lib/widgets/chart/renders/chart_preview.dart
import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../core/utils/chart_data_processor.dart';
import '../../../core/config/chart_types.dart';
import 'chart_render.dart';

class ChartPreview extends StatelessWidget {
  final ChartWidget chart;
  final DataSource? dataSource;
  final Map<String, dynamic> options;

  const ChartPreview({
    super.key,
    required this.chart,
    this.dataSource,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    final sourceToUse = dataSource ?? chart.dataSource;

    if (sourceToUse == null) {
      return const Center(child: Text('请选择数据源'));
    }

    if (chart.dimensions.isEmpty || chart.measures.isEmpty) {
      return const Center(child: Text('请配置维度和度量'));
    }

    try {
      final processor = ChartDataProcessor();
      final data = processor.processData(
        sourceToUse.records,
        chart.dimensions,
        chart.measures,
      );

      final chartType = ChartType.values.firstWhere(
            (type) => type.name == chart.type,
        orElse: () => ChartType.bar,
      );

      // 直接返回 ChartRender，不使用 Card 包装
      return ChartRender(
        type: chartType,
        data: data,
        measures: chart.measures,
        chartName: chart.name,
        options: options,
      );
    } catch (e) {
      return Center(child: Text('数据处理错误: $e'));
    }
  }
}