// lib/widgets/dashboard/chart_container.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../chart/renders/chart_preview.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

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

  bool get isMobile {
    if (kIsWeb) {
      return MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .size.width < 600;
    }
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 移动端时设置较小的高度
        final minHeight = isMobile ? 200.0 : 200.0;
        final maxHeight = isMobile ? 280.0 : constraints.maxHeight;

        return Card(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
              maxHeight: maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 添加这个确保不会过度扩展
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 标题区域
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              chart.type == 'pie' ? Icons.pie_chart
                                  : chart.type == 'line' ? Icons.show_chart
                                  : Icons.bar_chart,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                chart.name,
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isEditMode)
                        Row(
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
                    ],
                  ),
                ),

                // 分隔线
                const Divider(height: 1, thickness: 0.5),

                // 图表内容
                Expanded(
                  child: SizedBox(
                    height: isMobile ? 220.0 : null,  // 移动端固定较小的高度
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChartPreview(chart: chart),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}