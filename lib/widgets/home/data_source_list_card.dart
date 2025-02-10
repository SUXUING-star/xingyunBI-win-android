import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/models.dart';
import '../../widgets/datasource/data_source_preview.dart';

class DataSourceListCard extends StatelessWidget {
  const DataSourceListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '数据源',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushNamed(context, '/datasources');
                  },
                  tooltip: '添加数据源',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('dataSources').listenable(),
              builder: (context, box, child) {
                final dataSources = box.values.toList().cast<DataSource>();

                if (dataSources.isEmpty) {
                  return _EmptyDataSourceState();
                }

                return _DataSourceListView(dataSources: dataSources);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDataSourceState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storage_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无数据源',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '点击右上角按钮添加您的第一个数据源',
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

class _DataSourceListView extends StatelessWidget {
  final List<DataSource> dataSources;

  const _DataSourceListView({required this.dataSources});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: dataSources.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final source = dataSources[index];
        return ListTile(
          title: Text(source.name),
          subtitle: Text(
            '${source.records.length} 条记录',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => DataSourcePreview(dataSource: source),
                  );
                },
                tooltip: '预览数据源',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteDialog(context, source),
                tooltip: '删除数据源',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, DataSource source) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除数据源'),
        content: const Text('确定要删除这个数据源吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Hive.box('dataSources').delete(source.id);
              Navigator.pop(context);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}