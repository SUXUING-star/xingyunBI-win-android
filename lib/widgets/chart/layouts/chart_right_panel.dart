// lib/widgets/chart/layouts/chart_right_panel.dart
import 'package:flutter/material.dart';
import '../../../core/config/chart_types.dart';

class ChartRightPanel extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const ChartRightPanel({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '图表类型',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                for (final type in ChartType.values)
                  _buildChartTypeOption(context, type),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTypeOption(BuildContext context, ChartType type) {
    final isSelected = selectedType == type.name;

    IconData getIconForType(ChartType type) {
      switch (type) {
        case ChartType.bar:
          return Icons.bar_chart;
        case ChartType.line:
          return Icons.show_chart;
        case ChartType.pie:
          return Icons.pie_chart;
        case ChartType.area:
          return Icons.area_chart;
        case ChartType.scatter:
          return Icons.scatter_plot;
        case ChartType.radar:
          return Icons.radar;
        case ChartType.heatmap:
          return Icons.grid_on;
        case ChartType.bubble:
          return Icons.bubble_chart;
        case ChartType.waterfall:
          return Icons.waterfall_chart;
        case ChartType.boxplot:
          return Icons.candlestick_chart;
      }
    }

    return Card(
      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      child: InkWell(
        onTap: () => onTypeChanged(type.name),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                getIconForType(type),
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
              const SizedBox(width: 12),
              Text(
                type.label,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}