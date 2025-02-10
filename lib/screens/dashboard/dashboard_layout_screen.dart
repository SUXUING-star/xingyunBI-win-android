//lib/screens/dashboard_layout_screen.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'dart:math' show max;
import '../../widgets/dashboard/dashboard_layout_editor_grid.dart';
class DashboardLayoutScreen extends StatefulWidget {
  final List<ChartWidget> charts;
  final Map<String, dynamic> layout;
  final Function(Map<String, dynamic>) onSave;

  const DashboardLayoutScreen({
    super.key,
    required this.charts,
    required this.layout,
    required this.onSave,
  });

  @override
  State<DashboardLayoutScreen> createState() => _DashboardLayoutScreenState();
}

class _DashboardLayoutScreenState extends State<DashboardLayoutScreen> {
  late Map<String, dynamic> layout;

  @override
  void initState() {
    super.initState();
    layout = Map.from(widget.layout);
    if (layout.isEmpty) {
      _initializeDefaultLayout();
    }
  }

  void _initializeDefaultLayout() {
    // 使用绝对定位的默认布局
    const defaultWidth = 400.0;
    const defaultHeight = 300.0;
    const padding = 16.0;

    double currentX = padding;
    double currentY = padding;
    double maxHeight = 0;

    for (final chart in widget.charts) {
      layout[chart.id] = {
        'x': currentX,
        'y': currentY,
        'width': defaultWidth,
        'height': defaultHeight,
      };

      currentX += defaultWidth + padding;
      maxHeight = defaultHeight;

      // 自动换行
      if (currentX + defaultWidth > 1200) { // 假设最大宽度
        currentX = padding;
        currentY += maxHeight + padding;
        maxHeight = 0;
      }
    }
  }

  Map<String, dynamic> _convertLayout() {
    final convertedLayout = <String, dynamic>{};
    for (final chart in widget.charts) {
      final chartLayout = layout[chart.id];
      if (chartLayout == null) continue;

      // 确保所有必需的值都存在
      final x = (chartLayout['x'] as num?)?.toDouble() ?? 0.0;
      final y = (chartLayout['y'] as num?)?.toDouble() ?? 0.0;
      final width = (chartLayout['width'] as num?)?.toDouble() ?? 1.0;
      final height = (chartLayout['height'] as num?)?.toDouble() ?? 1.0;

      convertedLayout[chart.id] = {
        'row': (y / 300.0).clamp(0.0, double.infinity),
        'col': (x / 400.0).clamp(0.0, double.infinity),
        'width': (width / 400.0).clamp(0.1, 2.0),
        'height': (height / 300.0).clamp(0.1, 2.0),
        'order': chartLayout['order'] ?? 0,
      };
    }
    return convertedLayout;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑仪表盘布局'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final convertedLayout = _convertLayout();
              widget.onSave(convertedLayout);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return DashboardLayoutEditorGrid(
            charts: widget.charts,
            layout: layout,
            onLayoutChanged: (newLayout) {
              setState(() {
                layout = newLayout;
              });
            },
          );
        },
      ),
    );
  }
}