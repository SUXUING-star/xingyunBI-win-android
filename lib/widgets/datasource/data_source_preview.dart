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
  // 添加 ScrollController
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
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
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
            Container(
              height: 120,
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
                        return // 修改字段信息卡片部分的代码
                            Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            width: 220, // 增加宽度以更好地容纳长字段名
                            child: Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 图标和类型放在上面一行
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Icon(
                                            field.isNumeric
                                                ? Icons.numbers
                                                : field.isDate
                                                    ? Icons.calendar_today
                                                    : Icons.text_fields,
                                            size: 16,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _getFieldTypeDisplay(field),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // 字段名称放在下面，允许换行
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

            const Divider(height: 32),

            // 数据预览区域
            Text(
              '数据预览',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                // 添加 ClipRRect 来处理圆角问题
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      // 删除 IntrinsicWidth，改用固定宽度的 Container
                      child: Container(
                        // 设置一个最小宽度，确保可以水平滚动
                        width: widget.dataSource.fields.length * 200.0,
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
                                      width: 200,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              color: Theme.of(context)
                                                  .dividerColor),
                                          bottom: BorderSide(
                                              color: Theme.of(context)
                                                  .dividerColor),
                                        ),
                                      ),
                                      child: Text(
                                        field.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow:
                                            TextOverflow.ellipsis, // 添加文字溢出处理
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
                                // 包装每一行以处理背景色
                                decoration: BoxDecoration(
                                  color: i.isEven
                                      ? Colors.transparent
                                      : Theme.of(context)
                                          .hoverColor
                                          .withOpacity(0.05),
                                ),
                                child: Row(
                                  children: [
                                    for (var field in widget.dataSource.fields)
                                      Container(
                                        width: 200,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                color: Theme.of(context)
                                                    .dividerColor),
                                            bottom: BorderSide(
                                                color: Theme.of(context)
                                                    .dividerColor),
                                          ),
                                        ),
                                        child: Text(
                                          _formatValue(widget.dataSource
                                              .records[i][field.name]),
                                          overflow:
                                              TextOverflow.ellipsis, // 添加文字溢出处理
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
