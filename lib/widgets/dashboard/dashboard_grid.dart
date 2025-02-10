// lib/widgets/dashboard/dashboard_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_grid_layout/flutter_grid_layout.dart';
import '../../models/models.dart';
import '../dashboard/chart_container.dart';
import 'dart:math' show max;

class DashboardGrid extends StatelessWidget {
  final List<ChartWidget> charts;
  final Map<String, dynamic> layout;
  final Function(ChartWidget) onEditChart;
  final Function(ChartWidget) onDeleteChart;

  const DashboardGrid({
    super.key,
    required this.charts,
    required this.layout,
    required this.onEditChart,
    required this.onDeleteChart,
  });

  @override
  Widget build(BuildContext context) {
    if (charts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无图表',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    // 计算网格大小
    double maxRow = 0;
    double maxCol = 0;
    layout.forEach((chartId, pos) {
      final row = pos['row'] + pos['height'];
      final col = pos['col'] + pos['width'];
      maxRow = max(maxRow, row);
      maxCol = max(maxCol, col);
    });

    // 确保至少有2行2列
    maxRow = max(maxRow, 2.0);
    maxCol = max(maxCol, 2.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        // 计算每个网格单元的宽度和高度
        final gridWidth = constraints.maxWidth;
        final gridHeight = constraints.maxHeight;
        final columnWidth = gridWidth / 2;
        final rowHeight = gridHeight / maxRow.ceil();

        return GridContainer(
          columns: [
            columnWidth / gridWidth,
            columnWidth / gridWidth
          ],
          rows: List.generate(
              maxRow.ceil(),
                  (index) => rowHeight / gridHeight
          ),
          children: charts.map((chart) {
            final itemLayout = layout[chart.id] ?? {
              'row': 0.0,
              'col': 0.0,
              'width': 1.0,
              'height': 1.0,
              'order': 0,
            };

            return GridItem(
              order: itemLayout['order'] ?? 0,
              start: Size(
                itemLayout['col'].toDouble(),
                itemLayout['row'].toDouble(),
              ),
              end: Size(
                (itemLayout['col'] + itemLayout['width']).toDouble(),
                (itemLayout['row'] + itemLayout['height']).toDouble(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChartContainer(
                  chart: chart,
                  onEdit: () => onEditChart(chart),
                  onDelete: () => onDeleteChart(chart),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}