import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../models/models.dart';
import '../../../../core/utils/chart_data_processor.dart';


class RadarChartRenderer extends CustomPainter {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;
  final Function(String)? onTooltip;

  RadarChartRenderer({
    required this.data,
    required this.measures,
    this.options = const {},
    this.onTooltip,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.8;

    _drawBackground(canvas, center, radius);
    _drawAxis(canvas, center, radius);
    _drawData(canvas, center, radius);
    _drawLabels(canvas, center, radius);
  }

  void _drawBackground(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke;

    // Draw concentric circles to represent background rings
    for (int i = 1; i <= 5; i++) {
      final path = Path();
      for (int j = 0; j < data.length; j++) {
        final angle = 2 * math.pi * j / data.length - math.pi / 2;
        final point = Offset(
          center.dx + radius * i / 5 * math.cos(angle),
          center.dy + radius * i / 5 * math.sin(angle),
        );
        if (j == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  void _drawAxis(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw lines from the center to each dimension point
    for (int i = 0; i < data.length; i++) {
      final angle = 2 * math.pi * i / data.length - math.pi / 2;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, point, paint);
    }
  }

  void _drawData(Canvas canvas, Offset center, double radius) {
    // Find the maximum value across all data points and measures
    double maxValue = 0;
    for (var item in data) {
      for (var measure in measures) {
        final value = _parseValue(item.values[measure.name]);
        if (value > maxValue) maxValue = value.toDouble();
      }
    }

    // Iterate through each measure to draw a separate radar polygon for it
    for (var measure in measures) {
      final path = Path();
      final points = <Offset>[];

      for (int i = 0; i < data.length; i++) {
        final angle = 2 * math.pi * i / data.length - math.pi / 2;
        final value = _parseValue(data[i].values[measure.name]);
        // Adjust the radius based on the data value relative to the maximum value
        final adjustedRadius = radius * (value / maxValue);
        final point = Offset(
          center.dx + adjustedRadius * math.cos(angle),
          center.dy + adjustedRadius * math.sin(angle),
        );
        points.add(point);

        // Construct the path for the polygon
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();

      // Draw the filled area of the radar polygon
      final paint = Paint()
        ..color = _getColor(measures.indexOf(measure)).withOpacity(0.2)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);

      // Draw the outline of the radar polygon
      paint
        ..color = _getColor(measures.indexOf(measure))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(path, paint);

      // Draw data points for tooltip interaction (optional)
      if (options['tooltip'] ?? true) {
        for (int i = 0; i < points.length; i++) {
          final paint = Paint()
            ..color = _getColor(measures.indexOf(measure))
            ..style = PaintingStyle.fill;
          canvas.drawCircle(points[i], 3, paint);
        }
      }
    }
  }

  // Returns a color based on the index of the measure
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

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw labels for each dimension
    for (int i = 0; i < data.length; i++) {
      final angle = 2 * math.pi * i / data.length - math.pi / 2;
      final point = Offset(
        center.dx + (radius + 20) * math.cos(angle),
        center.dy + (radius + 20) * math.sin(angle),
      );

      textPainter.text = TextSpan(
        text: data[i].dimension,
        style: TextStyle(color: Colors.black, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        point.translate(-textPainter.width / 2, -textPainter.height / 2),
      );
    }
  }

  // Parses a dynamic value to a number (double), handling null or string inputs
  num _parseValue(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever the painter is rebuilt
  }
}