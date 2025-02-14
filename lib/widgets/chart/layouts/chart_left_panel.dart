// lib/widgets/chart/layouts/chart_left_panel.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/models.dart';
import 'dart:io';

class ChartLeftPanel extends StatefulWidget {
  final DataSource? selectedDataSource;
  final Function(DataSource?) onDataSourceChanged;

  const ChartLeftPanel({
    super.key,
    this.selectedDataSource,
    required this.onDataSourceChanged,
  });

  @override
  State<ChartLeftPanel> createState() => _ChartLeftPanelState();
}

class _ChartLeftPanelState extends State<ChartLeftPanel> {
  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    return SizedBox(
      width: isAndroid ? 140 : 200,
      child: Column(
        children: [
          // 选择数据源卡片
          Card(
            child: Padding(
              padding: EdgeInsets.all(isAndroid ? 8.0 : 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '选择数据源',
                    style: TextStyle(
                      fontSize: isAndroid ? 11.0 : 13.0, // 减小标题文字大小
                      fontWeight: FontWeight.w500, // 调整字重
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  SizedBox(height: isAndroid ? 6.0 : 8.0),
                  ValueListenableBuilder(
                    valueListenable: Hive.box('dataSources').listenable(),
                    builder: (context, box, child) {
                      final dataSources = box.values.toList().cast<DataSource>();

                      if (dataSources.isEmpty) {
                        return Text(
                          '暂无可用数据源',
                          style: TextStyle(
                            fontSize: isAndroid ? 11.0 : 13.0,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        );
                      }

                      final items = dataSources.map((source) {
                        return DropdownMenuItem<DataSource>(
                          value: source,
                          child: Text(
                            source.name,
                            style: TextStyle(
                              fontSize: isAndroid ? 11.0 : 13.0, // 减小下拉菜单文字大小
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList();

                      final isValidSelection = widget.selectedDataSource == null ||
                          dataSources.any((source) => source == widget.selectedDataSource);

                      return Theme(
                        data: Theme.of(context).copyWith(
                          // 自定义下拉菜单样式
                          textTheme: Theme.of(context).textTheme.copyWith(
                            bodyMedium: TextStyle(
                              fontSize: isAndroid ? 11.0 : 13.0,
                            ),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: isAndroid ? 6.0 : 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButton<DataSource>(
                              value: isValidSelection ? widget.selectedDataSource : null,
                              hint: Text(
                                '选择数据源',
                                style: TextStyle(
                                  fontSize: isAndroid ? 11.0 : 13.0,
                                ),
                              ),
                              isExpanded: true,
                              items: items,
                              onChanged: (value) {
                                widget.onDataSourceChanged(value);
                              },
                              menuMaxHeight: 300, // 限制下拉菜单高度
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isAndroid ? 4.0 : 8.0),
          // 可用字段列表
          Expanded(
            child: widget.selectedDataSource == null
                ? const Card(
              child: Center(child: Text('请先选择数据源')),
            )
                : _FieldList(dataSource: widget.selectedDataSource!),
          ),
        ],
      ),
    );
  }
}

class _FieldList extends StatelessWidget {
  final DataSource dataSource;
  final ScrollController _scrollController = ScrollController();

  _FieldList({required this.dataSource});

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(isAndroid ? 8.0 : 16.0),
            child: Text(
              '可用字段',
              style: TextStyle(
                fontSize: isAndroid ? 11.0 : 13.0,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(isAndroid ? 4 : 8),
                itemCount: dataSource.fields.length,
                itemBuilder: (context, index) => _buildDraggableField(
                  context,
                  dataSource.fields[index],
                  index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableField(BuildContext context, Field field, int index) {
    final isAndroid = Platform.isAndroid;
    return LongPressDraggable<Field>(  // 改用 LongPressDraggable
      data: field,
      delay: const Duration(milliseconds: 150),  // 添加一个短暂的延迟
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isAndroid ? 8 : 12,
            vertical: isAndroid ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.drag_indicator,
                size: isAndroid ? 14 : 16,
                color: Colors.white,
              ),
              SizedBox(width: isAndroid ? 4 : 8),
              Text(
                field.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isAndroid ? 11 : 13,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: isAndroid ? 2 : 4),
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isAndroid ? 8 : 12,
            vertical: isAndroid ? 2 : 4,
          ),
          leading: Icon(
            Icons.drag_indicator,
            size: isAndroid ? 16 : 18,
            color: Colors.grey.shade600,
          ),
          title: Text(
            field.name,
            style: TextStyle(
              fontSize: isAndroid ? 11 : 13,
            ),
          ),
          subtitle: Text(
            field.type,
            style: TextStyle(
              fontSize: isAndroid ? 10 : 12,
            ),
          ),
        ),
      ),
    );
  }
}