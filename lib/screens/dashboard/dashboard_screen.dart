// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/models.dart';
import '../../widgets/dashboard/dashboard_grid.dart';
import '../chart/chart_editor_screen.dart';
import 'dashboard_layout_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Dashboard? dashboard;

  const DashboardScreen({super.key, this.dashboard});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Dashboard currentDashboard;
  int itemsPerRow = 2; // 默认每行两个图表

  @override
  void initState() {
    super.initState();
    if (widget.dashboard == null) {
      final now = DateTime.now();
      final defaultName = '未命名仪表盘_${now.year}${now.month}${now.day}_${now.hour}${now.minute}';
      currentDashboard = Dashboard(
        id: const Uuid().v4(),
        name: defaultName,
        charts: [],
        layout: {},
      );
    } else {
      currentDashboard = widget.dashboard!;
    }
  }

  void _addChartToLayout(ChartWidget chart) {
    final newLayout = Map<String, dynamic>.from(currentDashboard.layout);
    final chartsCount = currentDashboard.charts.length;

    final row = (chartsCount / itemsPerRow).floor();
    final col = chartsCount % itemsPerRow;

    newLayout[chart.id] = {
      'row': row.toDouble(),
      'col': col.toDouble(),
      'width': 1.0,
      'height': 1.0,
      'order': newLayout.length,
    };

    setState(() {
      currentDashboard = Dashboard(
        id: currentDashboard.id,
        name: currentDashboard.name,
        charts: [...currentDashboard.charts, chart],
        layout: newLayout,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56, // 减少高度
        title: GestureDetector(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  currentDashboard.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: _showEditNameDialog,
                tooltip: "编辑仪表盘名称",
              )
            ],
          ),
        ),
        actions: [
          // 保持原有的操作按钮
          SegmentedButton<int>(
            segments: const [
              ButtonSegment<int>(value: 2, label: Text('每行两个')),
            ],
            selected: {itemsPerRow},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                itemsPerRow = newSelection.first;
                _updateLayout();
              });
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add_chart),
            onPressed: _createNewChart,
            tooltip: '添加图表',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDashboard,
            tooltip: '保存仪表盘',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // 减少内边距
        child: DashboardGrid(
          charts: currentDashboard.charts,
          layout: currentDashboard.layout,
          onEditChart: _editChart,
          onDeleteChart: _deleteChart,
        ),
      ),
    );
  }

  void _updateLayout() {
    final newLayout = <String, dynamic>{};
    for (var i = 0; i < currentDashboard.charts.length; i++) {
      final chart = currentDashboard.charts[i];
      final row = (i / itemsPerRow).floor();
      final col = i % itemsPerRow;

      newLayout[chart.id] = {
        'row': row.toDouble(),
        'col': col.toDouble(),
        'width': 1.0,
        'height': 1.0,
        'order': i,
      };
    }

    setState(() {
      currentDashboard = Dashboard(
        id: currentDashboard.id,
        name: currentDashboard.name,
        charts: currentDashboard.charts,
        layout: newLayout,
      );
    });
  }
  void _editLayout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardLayoutScreen(
          charts: currentDashboard.charts,
          layout: currentDashboard.layout,
          onSave: (newLayout) {
            setState(() {
              currentDashboard = Dashboard(
                id: currentDashboard.id,
                name: currentDashboard.name,
                charts: currentDashboard.charts,
                layout: newLayout,
              );
            });
          },
        ),
      ),
    );
  }

  void _createNewChart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChartEditorScreen(
          onSave: (chart) {
            _addChartToLayout(chart);
          },
        ),
      ),
    );
  }

  void _editChart(ChartWidget chart) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChartEditorScreen(
          chart: chart,
          onSave: (updatedChart) {
            setState(() {
              final index = currentDashboard.charts.indexWhere((c) => c.id == chart.id);
              if (index != -1) {
                final newCharts = List<ChartWidget>.from(currentDashboard.charts);
                newCharts[index] = updatedChart;
                currentDashboard = Dashboard(
                  id: currentDashboard.id,
                  name: currentDashboard.name,
                  charts: newCharts,
                  layout: currentDashboard.layout,
                );
              }
            });
          },
        ),
      ),
    );
  }
  void _showEditNameDialog() {
    final TextEditingController controller = TextEditingController(text: currentDashboard.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑仪表盘名称'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '仪表盘名称',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  currentDashboard = Dashboard(
                    id: currentDashboard.id,
                    name: controller.text,
                    charts: currentDashboard.charts,
                    layout: currentDashboard.layout,
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _deleteChart(ChartWidget chart) {
    setState(() {
      final newCharts =
      currentDashboard.charts.where((c) => c.id != chart.id).toList();
      final newLayout = Map<String, dynamic>.from(currentDashboard.layout)
        ..remove(chart.id);
      currentDashboard = Dashboard(
        id: currentDashboard.id,
        name: currentDashboard.name,
        charts: newCharts,
        layout: newLayout,
      );
    });
  }

  Future<void> _saveDashboard() async {
    if (currentDashboard.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入仪表盘名称')),
      );
      return;
    }

    await Hive.box('dashboards').put(currentDashboard.id, currentDashboard);
    if (mounted) {
      Navigator.pop(context);
    }
  }
}