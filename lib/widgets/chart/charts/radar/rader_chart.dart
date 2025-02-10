import 'package:flutter/material.dart';
import '../../../../core/utils/chart_data_processor.dart';
import '../../../../models/models.dart';
import 'radar_chart_render.dart';
import 'dart:math' as math;


class RadarChartWidget extends StatefulWidget {
  final List<ChartData> data;
  final List<Field> measures;
  final Map<String, dynamic> options;

  const RadarChartWidget({
    super.key,
    required this.data,
    required this.measures,
    this.options = const {},
  });

  @override
  State<RadarChartWidget> createState() => _RadarChartWidgetState();
}

class _RadarChartWidgetState extends State<RadarChartWidget> {
  String? tooltipText;
  Offset? tooltipPosition;

  void _handleHover(PointerEvent details) {
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.position);
    _checkTooltip(localPosition);
  }

  void _checkTooltip(Offset position) {
    final size = context.size!;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.8;

    for (var measure in widget.measures) {
      for (int i = 0; i < widget.data.length; i++) {
        final angle = 2 * math.pi * i / widget.data.length - math.pi / 2;
        final value = widget.data[i].values[measure.name] ?? 0;
        final maxValue = _getMaxValue();

        final point = Offset(
          center.dx + radius * (value / maxValue) * math.cos(angle),
          center.dy + radius * (value / maxValue) * math.sin(angle),
        );

        if ((position - point).distance < 10) {
          setState(() {
            tooltipText = "${widget.data[i].dimension}\n${measure.name}: $value";
            tooltipPosition = point;
          });
          return;
        }
      }
    }

    setState(() {
      tooltipText = null;
      tooltipPosition = null;
    });
  }

  double _getMaxValue() {
    double maxValue = 0;
    for (var item in widget.data) {
      for (var measure in widget.measures) {
        final value = (item.values[measure.name] ?? 0) as num;
        if (value > maxValue) maxValue = value.toDouble();
      }
    }
    return maxValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              MouseRegion(
                onHover: _handleHover,
                onExit: (_) => setState(() {
                  tooltipText = null;
                  tooltipPosition = null;
                }),
                child: CustomPaint(
                  painter: RadarChartRenderer(
                    data: widget.data,
                    measures: widget.measures,
                    options: widget.options,
                  ),
                  size: Size.infinite,
                ),
              ),
              if (tooltipText != null && tooltipPosition != null)
                Positioned(
                  left: tooltipPosition!.dx,
                  top: tooltipPosition!.dy - 30,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tooltipText!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.measures.map((measure) {
                    final index = widget.measures.indexOf(measure);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getColor(index),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(measure.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
}