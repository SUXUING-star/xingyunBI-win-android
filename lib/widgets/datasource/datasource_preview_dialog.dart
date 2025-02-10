// lib/widgets/datasource_preview_dialog.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';

class DataSourcePreviewDialog extends StatelessWidget {
  final DataSource dataSource;

  const DataSourcePreviewDialog({
    super.key,
    required this.dataSource,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataSource.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '字段概览',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            // 字段列表
            ListView.builder(
              shrinkWrap: true,
              itemCount: dataSource.fields.length,
              itemBuilder: (context, index) {
                final field = dataSource.fields[index];
                return ListTile(
                  leading: const Icon(Icons.view_column),
                  title: Text(field.name),
                  subtitle: const Text('维度'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}