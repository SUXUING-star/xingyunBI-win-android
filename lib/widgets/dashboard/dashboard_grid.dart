// lib/widgets/dashboard/dashboard_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_grid_layout/flutter_grid_layout.dart';
import '../../models/models.dart';
import '../dashboard/chart_container.dart';
import 'dart:math' show max;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

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

  bool get isMobile {
    if (kIsWeb) {
      return MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .size.width < 600;
    }
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

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

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          // 移动端使用 ListView
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: charts.length,
            itemBuilder: (context, index) {
              final chart = charts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ChartContainer(
                  chart: chart,
                  onEdit: () => onEditChart(chart),
                  onDelete: () => onDeleteChart(chart),
                ),
              );
            },
          );
        }

        // 桌面端保持原有的网格布局
        double maxRow = 0;
        double maxCol = 0;
        layout.forEach((chartId, pos) {
          maxRow = max(maxRow, (pos['row'] ?? 0) + (pos['height'] ?? 1));
          maxCol = max(maxCol, (pos['col'] ?? 0) + (pos['width'] ?? 1));
        });

        maxRow = max(maxRow, 2.0);
        maxCol = max(maxCol, 2.0);

        return GridContainer(
          columns: [0.5, 0.5],
          rows: List.generate(
            maxRow.ceil(),
                (index) => 1.0 / maxRow,
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