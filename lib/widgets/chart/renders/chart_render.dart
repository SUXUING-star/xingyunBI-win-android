// lib/widgets/chart/renders/chart_render.dart
import 'package:flutter/material.dart';
import '../../../core/utils/chart_data_processor.dart';
import '../../../models/models.dart';
import '../../../core/config/chart_types.dart';
import '../charts/bar_chart.dart';
import '../charts/line_chart.dart';
import '../charts/pie_chart.dart';
import '../charts/radar/rader_chart.dart';
import '../charts/buble_chart.dart';
import '../charts/waterfall_chart.dart';
import '../charts/heatmap_chart.dart';
import '../charts/scatter_chart.dart';
import '../charts/boxplot/boxplot_chart.dart';
import '../charts/area_chart.dart';

class ChartRender extends StatelessWidget {
  final ChartType type;
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;
  final String chartName;

  const ChartRender({
    super.key,
    required this.type,
    required this.data,
    required this.measures,
    required this.chartName,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    // 获取图表配置
    final config = chartConfigs[type];
    if (config == null) {
      return const Center(child: Text('不支持的图表类型'));
    }

    // 验证维度和度量数量
    if (measures.length > config.maxMeasures) {
      return Center(
        child: Text('该图表类型最多支持 ${config.maxMeasures} 个度量'),
      );
    }

    // 根据图表类型渲染对应的组件
    switch (type) {
      case ChartType.bar:
        return BarChartWidget(
          data: data,
          measures: measures,
          options: options,
        );
      case ChartType.line:
        return LineChartWidget(
          data: data,
          measures: measures,
          options: options,
        );
      case ChartType.pie:
        return PieChartWidget(
          data: data,
          measures: measures,
          options: options,
        );
      case ChartType.area:
        return AreaChartWidget(
          data: data,
          measures: measures,
          options: options,
        );
      case ChartType.scatter:
        return ScatterChartWidget(
          data: data,
          measures: measures,
          options: options,
        );
      case ChartType.radar:
        return RadarChartWidget(
          data: data,
          measures: measures,
          options: options,
        );
      case ChartType.heatmap:
        return HeatmapChartWidget(
          data: data,
          measures: measures,
          options: options,
        );
      case ChartType.bubble:
        return BubbleChartWidget(
          data: data,
          measures: measures,
          options: options,
        );
      case ChartType.waterfall:
        return WaterfallChartWidget(
          data: data,
          measures: measures,
          options: options,
        );
      case ChartType.boxplot:
        return BoxPlotChartWidget(
          data: data,
          measures: measures,
          options: options,
        );

    }
  }
}

class ChartPreview extends StatelessWidget {
  final ChartType type;
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;
  final String chartName;

  const ChartPreview({
    super.key,
    required this.type,
    required this.data,
    required this.measures,
    required this.chartName,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 图表标题
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                chartName,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),

            // 图表主体
            Expanded(
              child: ChartRender(
                type: type,
                data: data,
                measures: measures,
                chartName: chartName,
                options: options,
              ),
            ),
          ],
        ),
      ),
    );
  }
}