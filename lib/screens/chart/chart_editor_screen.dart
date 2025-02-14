// lib/screens/chart_editor_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/models.dart';
import '../../widgets/chart/renders/chart_preview.dart';
import '../../widgets/chart/layouts/chart_right_panel.dart';
import '../../widgets/chart/layouts/field_drop_zone.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/chart/layouts/chart_left_panel.dart';
import 'dart:io';

class ChartEditorScreen extends StatefulWidget {
  final DataSource? initialDataSource;
  final ChartWidget? chart;
  final Function(ChartWidget) onSave;

  const ChartEditorScreen({
    super.key,
    this.initialDataSource,
    this.chart,
    required this.onSave,
  });

  @override
  State<ChartEditorScreen> createState() => _ChartEditorScreenState();
}

class _ChartEditorScreenState extends State<ChartEditorScreen> {
  late String chartType;
  late TextEditingController nameController;
  List<Field> dimensions = [];
  List<Field> measures = [];
  DataSource? selectedDataSource;

  @override
  void initState() {
    super.initState();
    chartType = widget.chart?.type ?? 'bar';
    nameController = TextEditingController(text: widget.chart?.name ?? '新建图表');
    dimensions = widget.chart?.dimensions ?? [];
    measures = widget.chart?.measures ?? [];
    selectedDataSource = widget.initialDataSource ?? widget.chart?.dataSource;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(
                    fontSize: isAndroid ? 14 : 16,
                  ),
                  decoration: InputDecoration(
                    hintText: '请输入图表名称',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: isAndroid ? 8 : 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: _canSave() ? _saveChart : null,
              child: Text(
                '保存',
                style: TextStyle(fontSize: isAndroid ? 13 : 14),
              ),
            ),
            SizedBox(width: isAndroid ? 8 : 16),
          ],
        ),
      ),
      body: Row(
        children: [
          // 左侧数据源选择区域
          SizedBox(
            width: isAndroid ? 140 : 180,
            child: ChartLeftPanel(
              selectedDataSource: selectedDataSource,
              onDataSourceChanged: (value) {
                setState(() {
                  selectedDataSource = value;
                  dimensions.clear();
                  measures.clear();
                });
              },
            ),
          ),

          // 中间区域
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isAndroid ? 4 : 8),
              child: Column(
                children: [
                  // 图表预览区域
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(isAndroid ? 4 : 8),
                        child: selectedDataSource == null
                            ? const Center(child: Text('请选择数据源'))
                            : ChartPreview(
                          chart: ChartWidget(
                            id: widget.chart?.id ?? const Uuid().v4(),
                            name: nameController.text,
                            type: chartType,
                            dimensions: dimensions,
                            measures: measures,
                            settings: {},
                            dataSource: selectedDataSource!,
                          ),
                          dataSource: selectedDataSource,
                        ),
                      ),
                    ),
                  ),

                  // 维度度量拖拽区域
                  Container(
                    height: isAndroid ? 100 : 120,
                    margin: EdgeInsets.only(top: isAndroid ? 4 : 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: FieldDropZone(
                            title: '维度',
                            fields: dimensions,
                            onAccept: (field) {
                              setState(() {
                                if (!dimensions.contains(field)) {
                                  dimensions.add(field);
                                }
                              });
                            },
                            onRemove: (field) {
                              setState(() {
                                dimensions.remove(field);
                              });
                            },
                          ),
                        ),
                        SizedBox(width: isAndroid ? 4 : 8),
                        Expanded(
                          child: FieldDropZone(
                            title: '度量',
                            fields: measures,
                            onAccept: (field) {
                              setState(() {
                                if (!measures.contains(field)) {
                                  measures.add(field);
                                }
                              });
                            },
                            onRemove: (field) {
                              setState(() {
                                measures.remove(field);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 右侧图表类型选择
          SizedBox(
            width: isAndroid ? 160 : 200,
            child: ChartRightPanel(
              selectedType: chartType,
              onTypeChanged: (type) {
                setState(() => chartType = type);
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _canSave() {
    return nameController.text.isNotEmpty &&
        dimensions.isNotEmpty &&
        measures.isNotEmpty &&
        selectedDataSource != null;
  }

  void _saveChart() {
    widget.onSave(
      ChartWidget(
        id: widget.chart?.id ?? const Uuid().v4(),
        name: nameController.text,
        type: chartType,
        dimensions: dimensions,
        measures: measures,
        settings: {},
        dataSource: selectedDataSource!,
      ),
    );
    Navigator.of(context).pop();
  }
}