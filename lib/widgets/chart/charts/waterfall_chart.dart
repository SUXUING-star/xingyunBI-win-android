// lib/widgets/chart/charts/waterfall_chart.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/utils/chart_data_processor.dart';
import '../../../models/models.dart';

class WaterfallChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const WaterfallChartWidget({
    super.key,
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (measures.isEmpty) {
      return const Center(child: Text('瀑布图需要至少一个度量'));
    }

    // 计算累计值和中间值
    double sum = 0;
    final List<_WaterfallData> waterfallData = [];

    for (var i = 0; i < data.length; i++) {
      final value = data[i].values[measures[0].name] ?? 0;
      //在赋值给sum之前，把value转换为double类型
      double doubleValue = value.toDouble();
      sum += doubleValue;

      waterfallData.add(_WaterfallData(
        x: data[i].dimension,
        //在这里把value转换为double类型
        y: doubleValue,
        sum: sum,
        isTotal: i == data.length - 1,
      ));
    }

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelRotation: options['labelRotation'] ?? 0,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: measures[0].name),
      ),
      series: <ColumnSeries<_WaterfallData, String>>[
        ColumnSeries<_WaterfallData, String>(
          dataSource: waterfallData,
          xValueMapper: (_WaterfallData datum, _) => datum.x,
          yValueMapper: (_WaterfallData datum, _) => datum.y,
          width: 0.8,
          spacing: 0.2,
          // 使用 pointColorMapper 而不是 color 属性
          pointColorMapper: (_WaterfallData datum, _) {
            if (datum.isTotal) {
              return Colors.blue.shade500;
            } else if (datum.y >= 0) {
              return Colors.green.shade500;
            } else {
              return Colors.red.shade500;
            }
          },
          borderColor: Colors.grey.shade300,
          borderWidth: 1,
          // 数据标签设置
          dataLabelSettings: DataLabelSettings(
            isVisible: options['label'] ?? false,
            labelAlignment: ChartDataLabelAlignment.top,
          ),
          // 启用工具提示
          enableTooltip: true,
          // 在 y 轴使用总计值
          yAxisName: measures[0].name,
        ),
      ],
      // 启用工具提示行为
      tooltipBehavior: TooltipBehavior(
        enable: options['tooltip'] ?? true,
      ),
      // 添加图例
      legend: Legend(
        isVisible: options['legend'] ?? true,
        position: LegendPosition.bottom,
      ),
    );
  }
}

class _WaterfallData {
  final String x;
  final double y;
  final double sum;
  final bool isTotal;

  _WaterfallData({
    required this.x,
    required this.y,
    required this.sum,
    this.isTotal = false,
  });
}