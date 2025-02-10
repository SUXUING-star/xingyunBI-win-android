// lib/screens/datasource/datasource_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/file/file_parser.dart';
import '../../widgets/file_upload.dart';
import 'dart:typed_data';

class DataSourceScreen extends StatefulWidget {
  const DataSourceScreen({super.key});

  @override
  State<DataSourceScreen> createState() => _DataSourceScreenState();
}

class _DataSourceScreenState extends State<DataSourceScreen> {
  bool isLoading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入数据源'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.upload_file,
                    size: 48,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '上传数据文件',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '支持 CSV 和 Excel 文件格式',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    FileUploadWidget(
                      onFileSelected: _handleFileSelected,
                    ),

                  if (error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 32),
                  const _FileFormatInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleFileSelected(String fileName, Uint8List bytes) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      print('File selected: $fileName');
      print('File size: ${bytes.length} bytes');

      final extension = fileName.split('.').last.toLowerCase();
      if (!FileParser.supportedExtensions.contains(extension)) {
        throw Exception('不支持的文件格式：$extension');
      }

      // 解析文件
      final fileParser = FileParser();
      final dataSource = await fileParser.parse(
        context,  // 添加 context 参数
        fileName,
        bytes,
        extension,
      );

      if (dataSource != null) {  // 检查返回值是否为空
        // 保存到 Hive
        await Hive.box('dataSources').put(dataSource.id, dataSource);

        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print('Import error: $e');
      setState(() => error = '导入失败: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }
}

class _FileFormatInfo extends StatelessWidget {
  const _FileFormatInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '支持的文件格式',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildFormatTile(
          context,
          icon: Icons.table_chart,
          title: 'CSV 文件',
          description: '包含表头的 CSV 文件，使用逗号或制表符分隔',
        ),
        const SizedBox(height: 12),
        _buildFormatTile(
          context,
          icon: Icons.table_view,
          title: 'Excel 文件',
          description: 'Excel 工作簿 (.xlsx, .xls)，将使用第一个工作表的数据',
        ),
      ],
    );
  }

  Widget _buildFormatTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
      }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}