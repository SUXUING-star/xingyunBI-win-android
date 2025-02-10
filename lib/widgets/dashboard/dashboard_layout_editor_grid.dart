import 'package:flutter/material.dart';
import 'package:flutter_grid_layout/flutter_grid_layout.dart';
import '../../models/models.dart';
import '../dashboard/chart_container.dart';
import 'dart:math' show max;

class DashboardLayoutEditorGrid extends StatefulWidget {
  final List<ChartWidget> charts;
  final Map<String, dynamic> layout;
  final Function(Map<String, dynamic>) onLayoutChanged;

  const DashboardLayoutEditorGrid({
    super.key,
    required this.charts,
    required this.layout,
    required this.onLayoutChanged,
  });

  @override
  State<DashboardLayoutEditorGrid> createState() => _DashboardLayoutEditorGridState();
}

class _DashboardLayoutEditorGridState extends State<DashboardLayoutEditorGrid> {
  late Map<String, dynamic> layout;
  String? selectedChartId;
  bool isResizing = false;
  Offset? dragStartOffset;
  Map<String, dynamic>? dragStartLayout;

  @override
  void initState() {
    super.initState();
    layout = Map<String, dynamic>.from(widget.layout);
    if (layout.isEmpty) {
      _generateDefaultLayout();
    }
  }

  void _generateDefaultLayout() {
    // 默认每个图表占用一半宽度
    double currentRow = 0;
    double currentCol = 0;

    for (final chart in widget.charts) {
      layout[chart.id] = {
        'col': currentCol,
        'row': currentRow,
        'width': 1.0,  // 宽度为屏幕的一半
        'height': 0.5, // 高度为宽度的一半
      };

      // 移动到下一个位置
      currentCol += 1;
      if (currentCol >= 2) {  // 每行两个图表
        currentCol = 0;
        currentRow += 0.5;
      }
    }
  }

  void _handleDragStart(String chartId, Offset position) {
    final chartLayout = layout[chartId];
    if (chartLayout == null) return;

    setState(() {
      selectedChartId = chartId;
      dragStartOffset = position;
      // 确保正确的类型转换
      dragStartLayout = Map<String, dynamic>.from(chartLayout as Map);
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (selectedChartId == null ||
        dragStartOffset == null ||
        dragStartLayout == null) {
      return;
    }

    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final delta = localPosition - dragStartOffset!;

    setState(() {
      final currentLayout = layout[selectedChartId!];
      if (currentLayout == null) return;

      if (isResizing) {
        // 处理缩放
        final newWidth = ((currentLayout['width'] as num).toDouble() * box.size.width + delta.dx)
            .clamp(200.0, box.size.width);
        final newHeight = ((currentLayout['height'] as num).toDouble() * box.size.height + delta.dy)
            .clamp(150.0, box.size.height);

        layout[selectedChartId!] = {
          'col': (currentLayout['col'] as num).toDouble(),
          'row': (currentLayout['row'] as num).toDouble(),
          'width': newWidth / box.size.width,
          'height': newHeight / box.size.height,
        };
      } else {
        // 处理拖动
        final newCol = ((dragStartLayout!['col'] as num).toDouble() + delta.dx / box.size.width * 2)
            .clamp(0.0, 2.0 - (currentLayout['width'] as num).toDouble());
        final newRow = ((dragStartLayout!['row'] as num).toDouble() + delta.dy / box.size.height * 2)
            .clamp(0.0, double.infinity);

        layout[selectedChartId!] = {
          'col': newCol,
          'row': newRow,
          'width': (currentLayout['width'] as num).toDouble(),
          'height': (currentLayout['height'] as num).toDouble(),
        };
      }
      widget.onLayoutChanged(layout);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      selectedChartId = null;
      dragStartOffset = null;
      dragStartLayout = null;
      isResizing = false;
    });
  }

  void _handleResizeStart(String chartId, Offset position) {
    final chartLayout = layout[chartId];
    if (chartLayout == null) return;

    setState(() {
      selectedChartId = chartId;
      isResizing = true;
      dragStartOffset = position;
      // 确保正确的类型转换
      dragStartLayout = Map<String, dynamic>.from(chartLayout as Map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = constraints.maxWidth / 2;  // 基准宽度为屏幕一半
        final cellHeight = cellWidth * 0.75;  // 基准高度为宽度的75%

        return Stack(
          children: widget.charts.map((chart) {
            final chartLayout = layout[chart.id];
            if (chartLayout == null) return Container();

            final col = (chartLayout['col'] as num).toDouble();
            final row = (chartLayout['row'] as num).toDouble();
            final width = (chartLayout['width'] as num).toDouble();
            final height = (chartLayout['height'] as num).toDouble();

            return Positioned(
              left: col * cellWidth,
              top: row * cellHeight,
              width: width * cellWidth,
              height: height * cellHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedChartId == chart.id ?
                    Colors.blue : Colors.grey.withOpacity(0.5),
                    width: selectedChartId == chart.id ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    ChartContainer(
                      chart: chart,
                      isEditMode: true,
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        onPanStart: (details) => _handleDragStart(
                          chart.id,
                          details.globalPosition,
                        ),
                        onPanUpdate: _handleDragUpdate,
                        onPanEnd: _handleDragEnd,
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onPanStart: (details) => _handleResizeStart(
                          chart.id,
                          details.globalPosition,
                        ),
                        onPanUpdate: _handleDragUpdate,
                        onPanEnd: _handleDragEnd,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.open_with,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
class _DraggableChartContainer extends StatelessWidget {
  final ChartWidget chart;
  final Function(Offset) onDragStart;
  final Function(Offset) onDragUpdate;
  final Function() onDragEnd;
  final Function(Offset) onResizeStart;
  final Function(Offset) onResizeUpdate;
  final Function() onResizeEnd;

  const _DraggableChartContainer({
    required this.chart,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onResizeStart,
    required this.onResizeUpdate,
    required this.onResizeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 使用编辑模式的 ChartContainer
        ChartContainer(
          chart: chart,
          isEditMode: true, // 标记为编辑模式
        ),

        // 拖动手柄
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onPanStart: (details) => onDragStart(details.globalPosition),
            onPanUpdate: (details) => onDragUpdate(details.globalPosition),
            onPanEnd: (_) => onDragEnd(),
            child: Container(
              height: 40,
              color: Colors.blue.withOpacity(0.1),
              child: const Center(
                child: Icon(Icons.drag_handle, color: Colors.blue),
              ),
            ),
          ),
        ),

        // 调整大小手柄
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onPanStart: (details) => onResizeStart(details.globalPosition),
            onPanUpdate: (details) => onResizeUpdate(details.globalPosition),
            onPanEnd: (_) => onResizeEnd(),
            child: Container(
              width: 40,
              height: 40,
              color: Colors.blue.withOpacity(0.1),
              child: const Center(
                child: Icon(Icons.open_with, color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }
}