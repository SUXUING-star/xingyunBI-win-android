// lib/widgets/datasource_preview.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';

class DataSourcePreview extends StatelessWidget {
  final DataSource dataSource;
  static const int previewRows = 5;

  const DataSourcePreview({
    super.key,
    required this.dataSource,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      Text(
                        '${dataSource.records.length} 条记录',
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
            const SizedBox(height: 16),

            // 字段列表
            Text(
              '字段信息',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: dataSource.fields.length,
                itemBuilder: (context, index) {
                  final field = dataSource.fields[index];
                  return ListTile(
                    leading: Icon(
                      field.isNumeric ? Icons.numbers :
                      field.isDate ? Icons.calendar_today :
                      Icons.text_fields,
                    ),
                    title: Text(field.name),
                    subtitle: Text(_getFieldTypeDisplay(field)),
                  );
                },
              ),
            ),

            const Divider(),

            // 数据预览
            Text(
              '数据预览',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    for (var field in dataSource.fields)
                      DataColumn(label: Text(field.name)),
                  ],
                  rows: [
                    for (var i = 0; i < previewRows && i < dataSource.records.length; i++)
                      DataRow(
                        cells: [
                          for (var field in dataSource.fields)
                            DataCell(Text(
                              _formatValue(dataSource.records[i][field.name]),
                            )),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFieldTypeDisplay(Field field) {
    if (field.isNumeric) return '数值';
    if (field.isDate) return '日期';
    return '文本';
  }

  String _formatValue(dynamic value) {
    if (value == null) return '';
    if (value is DateTime) {
      return '${value.year}-${value.month}-${value.day}';
    }
    if (value is num) {
      return value.toString();
    }
    return value.toString();
  }
}