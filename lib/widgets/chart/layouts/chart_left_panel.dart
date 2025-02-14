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
      width: isAndroid? 120 : 200,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(isAndroid? 8.0 : 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '选择数据源',
                    style: TextStyle(
                      fontSize: isAndroid? 12.0 : 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isAndroid? 8.0 : 16.0),
                  ValueListenableBuilder(
                    valueListenable: Hive.box('dataSources').listenable(),
                    builder: (context, box, child) {
                      final dataSources = box.values.toList().cast<DataSource>();

                      // 检查数据源列表是否为空
                      if (dataSources.isEmpty) {
                        return const Text('暂无可用数据源');
                      }

                      // 确保下拉菜单项的值唯一性
                      final items = dataSources.map((source) {
                        return DropdownMenuItem<DataSource>(
                          value: source,
                          child: Text(
                            source.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList();

                      // 验证选中的值是否在可选项中
                      final isValidSelection = widget.selectedDataSource == null ||
                          dataSources.any((source) => source == widget.selectedDataSource);

                      return DropdownButton<DataSource>(
                        value: isValidSelection ? widget.selectedDataSource : null,
                        hint: const Text('选择数据源'),
                        isExpanded: true,
                        items: items,
                        onChanged: (value) {
                          widget.onDataSourceChanged(value);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isAndroid? 4.0 : 8.0),
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

  const _FieldList({required this.dataSource});

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(isAndroid? 8.0 : 16.0),
            child: Text(
              '可用字段',
              style: TextStyle(
                fontSize: isAndroid? 12.0 : 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: dataSource.fields.length,
              itemBuilder: (context, index) => _buildDraggableField(dataSource.fields[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableField(Field field) {
    final isAndroid = Platform.isAndroid;
    return Draggable<Field>(
      data: field,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.drag_indicator,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                field.name,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          dense: true,
          leading: const Icon(
            Icons.drag_indicator,
            size: 20,
          ),
          title: Text(field.name),
          subtitle: Text(field.type),
        ),
      ),
    );
  }
}