// lib/widgets/datasource_preview.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';

class DataSourcePreview extends StatefulWidget {
  final DataSource dataSource;
  static const int previewRows = 5;

  const DataSourcePreview({
    super.key,
    required this.dataSource,
  });

  @override
  State<DataSourcePreview> createState() => _DataSourcePreviewState();
}

class _DataSourcePreviewState extends State<DataSourcePreview> {
  final ScrollController _fieldsScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    _fieldsScrollController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isSmallScreen ? screenSize.width : 800,
          maxHeight: isSmallScreen ? screenSize.height * 0.9 : 600,
        ),
        // 添加一个 ScrollView 包裹整个内容
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题和关闭按钮
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.dataSource.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '${widget.dataSource.records.length} 条记录',
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

                // 字段信息区域
                Text(
                  '字段信息',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: isSmallScreen ? 100 : 120,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Scrollbar(
                      controller: _fieldsScrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        controller: _fieldsScrollController,
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicHeight(
                          child: Row(
                            children: widget.dataSource.fields.map((field) {
                              return Padding(
                                padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
                                child: SizedBox(
                                  width: isSmallScreen ? 180 : 220,
                                  child: Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 12 : 16,
                                        vertical: isSmallScreen ? 8 : 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Icon(
                                                  field.isNumeric
                                                      ? Icons.numbers
                                                      : field.isDate
                                                      ? Icons.calendar_today
                                                      : Icons.text_fields,
                                                  size: 16,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _getFieldTypeDisplay(field),
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            field.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Divider(height: 32),

                // 数据预览区域
                Text(
                  '数据预览',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                // 移除 Expanded，改用固定高度的 SizedBox
                SizedBox(
                  height: 300, // 为数据预览表格设置一个固定高度
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SingleChildScrollView(
                        controller: _verticalScrollController,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: widget.dataSource.fields.length * (isSmallScreen ? 160.0 : 200.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 表头行
                                Container(
                                  color: Theme.of(context).highlightColor,
                                  child: Row(
                                    children: [
                                      for (var field in widget.dataSource.fields)
                                        Container(
                                          width: isSmallScreen ? 160 : 200,
                                          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              right: BorderSide(color: Theme.of(context).dividerColor),
                                              bottom: BorderSide(color: Theme.of(context).dividerColor),
                                            ),
                                          ),
                                          child: Text(
                                            field.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // 数据行
                                for (var i = 0;
                                i < DataSourcePreview.previewRows &&
                                    i < widget.dataSource.records.length;
                                i++)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: i.isEven
                                          ? Colors.transparent
                                          : Theme.of(context).hoverColor.withOpacity(0.05),
                                    ),
                                    child: Row(
                                      children: [
                                        for (var field in widget.dataSource.fields)
                                          Container(
                                            width: isSmallScreen ? 160 : 200,
                                            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(color: Theme.of(context).dividerColor),
                                                bottom: BorderSide(color: Theme.of(context).dividerColor),
                                              ),
                                            ),
                                            child: Text(
                                              _formatValue(widget.dataSource.records[i][field.name]),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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