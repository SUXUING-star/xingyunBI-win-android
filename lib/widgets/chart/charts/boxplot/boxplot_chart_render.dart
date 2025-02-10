// lib/widgets/chart/charts/boxplot/boxplot_chart_render.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../models/models.dart';
import '../../../../core/utils/chart_data_processor.dart';

class BoxPlotChartRenderer extends CustomPainter {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  BoxPlotChartRenderer({
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || measures.isEmpty) return;

    final processedData = _processData();
    final stats = _calculateStats(processedData);

    // 计算绘图区域
    const padding = 40.0;
    final plotArea = Rect.fromLTWH(
      padding,
      padding,
      size.width - (padding * 2),
      size.height - (padding * 2),
    );

    _drawAxis(canvas, plotArea, stats);
    _drawBoxPlots(canvas, plotArea, processedData, stats);
  }

  void _drawAxis(Canvas canvas, Rect plotArea, _BoxPlotStats stats) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // 绘制Y轴
    canvas.drawLine(
      Offset(plotArea.left, plotArea.top),
      Offset(plotArea.left, plotArea.bottom),
      paint,
    );

    // 绘制X轴
    canvas.drawLine(
      Offset(plotArea.left, plotArea.bottom),
      Offset(plotArea.right, plotArea.bottom),
      paint,
    );

    // 绘制Y轴刻度
    final numTicks = 5;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    for (int i = 0; i <= numTicks; i++) {
      final y = plotArea.bottom - (i / numTicks) * plotArea.height;
      final value = stats.min + (i / numTicks) * (stats.max - stats.min);

      canvas.drawLine(
        Offset(plotArea.left - 5, y),
        Offset(plotArea.left, y),
        paint,
      );

      textPainter.text = TextSpan(
        text: value.toStringAsFixed(1),
        style: TextStyle(color: Colors.grey.shade700, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(plotArea.left - 8 - textPainter.width, y - textPainter.height / 2),
      );
    }
  }

  void _drawBoxPlots(
      Canvas canvas,
      Rect plotArea,
      Map<String, List<double>> processedData,
      _BoxPlotStats stats,
      ) {
    final categories = processedData.keys.toList();
    final boxWidth = plotArea.width / (categories.length * 2);

    int index = 0;
    for (var category in categories) {
      final values = processedData[category]!;
      final boxStats = _calculateBoxStats(values);

      final x = plotArea.left + (index * 2 + 1) * boxWidth;

      // 将数值映射到绘图区域
      final yScale = plotArea.height / (stats.max - stats.min);
      final mapToY = (double value) =>
      plotArea.bottom - (value - stats.min) * yScale;

      // 绘制箱体
      final boxPaint = Paint()
        ..color = Colors.blue.withOpacity(0.5)
        ..style = PaintingStyle.fill;

      final boxStrokePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      // 绘制箱体矩形
      final boxRect = Rect.fromLTRB(
        x - boxWidth / 2,
        mapToY(boxStats.q3),
        x + boxWidth / 2,
        mapToY(boxStats.q1),
      );

      canvas.drawRect(boxRect, boxPaint);
      canvas.drawRect(boxRect, boxStrokePaint);

      // 绘制中位线
      canvas.drawLine(
        Offset(x - boxWidth / 2, mapToY(boxStats.median)),
        Offset(x + boxWidth / 2, mapToY(boxStats.median)),
        boxStrokePaint..color = Colors.blue.shade900,
      );

      // 绘制须线
      canvas.drawLine(
        Offset(x, mapToY(boxStats.upperWhisker)),
        Offset(x, mapToY(boxStats.q3)),
        boxStrokePaint,
      );
      canvas.drawLine(
        Offset(x, mapToY(boxStats.lowerWhisker)),
        Offset(x, mapToY(boxStats.q1)),
        boxStrokePaint,
      );

      // 绘制须线的横线
      canvas.drawLine(
        Offset(x - boxWidth / 3, mapToY(boxStats.upperWhisker)),
        Offset(x + boxWidth / 3, mapToY(boxStats.upperWhisker)),
        boxStrokePaint,
      );
      canvas.drawLine(
        Offset(x - boxWidth / 3, mapToY(boxStats.lowerWhisker)),
        Offset(x + boxWidth / 3, mapToY(boxStats.lowerWhisker)),
        boxStrokePaint,
      );

      // 绘制类别标签
      final textPainter = TextPainter(
        text: TextSpan(
          text: category,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, plotArea.bottom + 8),
      );

      index++;
    }
  }

  Map<String, List<double>> _processData() {
    final Map<String, List<double>> groupedData = {};

    for (var item in data) {
      final category = item.dimension;
      final value = (item.values[measures[0].name] ?? 0).toDouble();

      if (!groupedData.containsKey(category)) {
        groupedData[category] = [];
      }
      groupedData[category]!.add(value);
    }

    // 对每个分组的数据进行排序
    groupedData.forEach((key, values) {
      values.sort();
    });

    return groupedData;
  }

  _BoxPlotStats _calculateStats(Map<String, List<double>> processedData) {
    double min = double.infinity;
    double max = double.negativeInfinity;

    for (var values in processedData.values) {
      if (values.isEmpty) continue;
      min = math.min(min, values.first);
      max = math.max(max, values.last);
    }

    // 确保最小值和最大值有一定的间距
    final range = max - min;
    min -= range * 0.1;
    max += range * 0.1;

    return _BoxPlotStats(min: min, max: max);
  }

  _IndividualBoxStats _calculateBoxStats(List<double> values) {
    if (values.isEmpty) {
      throw Exception('Cannot calculate box stats for empty data');
    }

    values.sort();
    final n = values.length;

    // 计算四分位数
    final q1Index = (n * 0.25).floor();
    final medianIndex = (n * 0.5).floor();
    final q3Index = (n * 0.75).floor();

    final q1 = values[q1Index];
    final median = values[medianIndex];
    final q3 = values[q3Index];

    final iqr = q3 - q1;
    final lowerFence = q1 - 1.5 * iqr;
    final upperFence = q3 + 1.5 * iqr;

    // 计算须线的位置（在围栏范围内的最大和最小值）
    double lowerWhisker = values.first;
    double upperWhisker = values.last;

    for (var value in values) {
      if (value >= lowerFence) {
        lowerWhisker = value;
        break;
      }
    }

    for (var value in values.reversed) {
      if (value <= upperFence) {
        upperWhisker = value;
        break;
      }
    }

    return _IndividualBoxStats(
      q1: q1,
      median: median,
      q3: q3,
      lowerWhisker: lowerWhisker,
      upperWhisker: upperWhisker,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BoxPlotStats {
  final double min;
  final double max;

  _BoxPlotStats({required this.min, required this.max});
}

class _IndividualBoxStats {
  final double q1;
  final double median;
  final double q3;
  final double lowerWhisker;
  final double upperWhisker;

  _IndividualBoxStats({
    required this.q1,
    required this.median,
    required this.q3,
    required this.lowerWhisker,
    required this.upperWhisker,
  });
}