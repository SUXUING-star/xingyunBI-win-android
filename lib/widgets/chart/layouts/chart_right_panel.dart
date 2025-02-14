// lib/widgets/chart/layouts/chart_right_panel.dart
import 'package:flutter/material.dart';
import '../../../core/config/chart_types.dart';
import 'dart:io';

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
    final isAndroid = Platform.isAndroid;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(isAndroid ? 12 : 16),
            child: Text(
              '图表类型',
              style: TextStyle(
                fontSize: isAndroid ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(isAndroid ? 4 : 8),
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
    final isAndroid = Platform.isAndroid;

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
      color: isSelected ? Theme
          .of(context)
          .primaryColor
          .withOpacity(0.1) : null,
      child: InkWell(
        onTap: () => onTypeChanged(type.name),
        child: Padding(
          padding: EdgeInsets.all(isAndroid ? 8 : 12),
          child: Row(
            children: [
              Icon(
                getIconForType(type),
                size: isAndroid ? 18 : 24,
                color: isSelected ? Theme
                    .of(context)
                    .primaryColor : null,
              ),
              SizedBox(width: isAndroid ? 8 : 12),
              Text(
                type.label,
                style: TextStyle(
                  fontSize: isAndroid ? 12 : 14,
                  color: isSelected ? Theme
                      .of(context)
                      .primaryColor : null,
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