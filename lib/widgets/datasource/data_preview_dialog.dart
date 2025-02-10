// lib/widgets/data_preview_dialog.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';

class DataPreviewDialog extends StatefulWidget {
  final String fileName;
  final List<List<dynamic>> rawData;
  final Function(List<Field>) onConfirm;

  const DataPreviewDialog({
    super.key,
    required this.fileName,
    required this.rawData,
    required this.onConfirm,
  });

  @override
  State<DataPreviewDialog> createState() => _DataPreviewDialogState();
}

class _DataPreviewDialogState extends State<DataPreviewDialog> {
  late List<_FieldConfig> fields;
  static const previewRows = 5; // 预览前5行数据

  @override
  void initState() {
    super.initState();
    fields = _detectFields();
  }

  List<_FieldConfig> _detectFields() {
    if (widget.rawData.isEmpty) return [];

    final headers = widget.rawData.first;
    final dataRows = widget.rawData.skip(1).toList();

    return List.generate(headers.length, (colIndex) {
      // 获取这一列的所有值
      final columnValues = dataRows.map((row) => row[colIndex]).toList();

      // 检测类型
      bool canBeNumber = columnValues.every((value) =>
      value == null ||
          value is num ||
          (value is String && num.tryParse(value?.toString() ?? '') != null)
      );

      bool canBeDate = columnValues.every((value) =>
      value == null ||
          value is DateTime ||
          (value is String && DateTime.tryParse(value) != null)
      );

      String autoType = 'string';
      if (canBeNumber) autoType = 'number';
      else if (canBeDate) autoType = 'date';

      return _FieldConfig(
        name: headers[colIndex].toString(),
        currentType: autoType,
        detectedTypes: [
          if (canBeNumber) 'number',
          if (canBeDate) 'date',
          'string',
        ],
        sampleValues: columnValues.take(previewRows).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '预览数据: ${widget.fileName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('字段名')),
                    const DataColumn(label: Text('类型')),
                    ...List.generate(
                      previewRows,
                          (index) => DataColumn(
                        label: Text('示例 ${index + 1}'),
                      ),
                    ),
                  ],
                  rows: fields.map((field) {
                    return DataRow(
                      cells: [
                        DataCell(Text(field.name)),
                        DataCell(
                          DropdownButton<String>(
                            value: field.currentType,
                            items: field.detectedTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(_typeDisplayName(type)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  field.currentType = value;
                                });
                              }
                            },
                          ),
                        ),
                        ...field.sampleValues.map((value) => DataCell(
                          Text(value?.toString() ?? 'null'),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final fieldList = fields.map((f) => Field(
                      name: f.name,
                      type: f.currentType,
                      isNumeric: f.currentType == 'number',
                      isDate: f.currentType == 'date',
                    )).toList();
                    widget.onConfirm(fieldList);
                    Navigator.pop(context);
                  },
                  child: const Text('确认'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _typeDisplayName(String type) {
    switch (type) {
      case 'number':
        return '数值';
      case 'date':
        return '日期';
      case 'string':
        return '文本';
      default:
        return type;
    }
  }
}

class _FieldConfig {
  final String name;
  String currentType;
  final List<String> detectedTypes;
  final List<dynamic> sampleValues;

  _FieldConfig({
    required this.name,
    required this.currentType,
    required this.detectedTypes,
    required this.sampleValues,
  });
}