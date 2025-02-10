import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/models.dart';

class DashboardListCard extends StatelessWidget {
  const DashboardListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ValueListenableBuilder(
        valueListenable: Hive.box('dashboards').listenable(),
        builder: (context, box, child) {
          final dashboards = box.values.toList().cast<Dashboard>();

          if (dashboards.isEmpty) {
            return _EmptyDashboardState();
          }

          return _DashboardListView(dashboards: dashboards);
        },
      ),
    );
  }
}

class _EmptyDashboardState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无仪表盘',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '点击右上角按钮创建您的第一个仪表盘',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardListView extends StatelessWidget {
  final List<Dashboard> dashboards;

  const _DashboardListView({required this.dashboards});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '我的仪表盘',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const Divider(height: 1),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dashboards.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final dashboard = dashboards[index];
            return ListTile(
              title: Text(dashboard.name),
              subtitle: Text('${dashboard.charts.length} 个图表'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard',
                        arguments: dashboard,
                      );
                    },
                    tooltip: '编辑仪表盘',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteDialog(context, dashboard),
                    tooltip: '删除仪表盘',
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/dashboard',
                  arguments: dashboard,
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, Dashboard dashboard) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除仪表盘'),
        content: const Text('确定要删除这个仪表盘吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Hive.box('dashboards').delete(dashboard.id);
              Navigator.pop(context);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}