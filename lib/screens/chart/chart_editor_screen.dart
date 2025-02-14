// lib/screens/chart_editor_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/models.dart';
import '../../widgets/chart/renders/chart_preview.dart';
import '../../widgets/chart/layouts/chart_right_panel.dart';
import '../../widgets/chart/layouts/field_drop_zone.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/chart/layouts/chart_left_panel.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chart == null ? '新建图表' : '编辑图表'),
        actions: [
          TextButton(
            onPressed: _canSave() ? _saveChart : null,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Row(
        children: [
          // 左侧数据源选择区域
          SizedBox(
            width: 180, // 略微缩小宽度
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
            flex: 3, // 增加中间区域的权重
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  // 图表名称输入
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: '图表名称',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 图表预览区域
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
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
                    height: 120, // 略微缩小高度
                    margin: const EdgeInsets.only(top: 8),
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
                        const SizedBox(width: 8),
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
            width: 200, // 略微缩小宽度
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