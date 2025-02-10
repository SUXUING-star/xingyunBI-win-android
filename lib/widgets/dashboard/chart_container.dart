// lib/widgets/dashboard/chart_container.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../chart/renders/chart_preview.dart';
class ChartContainer extends StatelessWidget {
  final ChartWidget chart;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool isEditMode;

  const ChartContainer({
    super.key,
    required this.chart,
    this.onDelete,
    this.onEdit,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Card(
      child: Stack(
        children: [
          if (!isEditMode)
            Positioned(
              top: 4,
              right: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onEdit,
                      tooltip: '编辑图表',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: onDelete,
                      tooltip: '删除图表',
                    ),
                ],
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isEditMode)
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        chart.type == 'pie' ? Icons.pie_chart
                            : chart.type == 'line' ? Icons.show_chart
                            : Icons.bar_chart,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        chart.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChartPreview(chart: chart),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return content;
  }
}