// lib/widgets/file_upload.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'dart:typed_data';

class FileUploadWidget extends StatefulWidget {
  final void Function(String fileName, Uint8List bytes) onFileSelected;
  final List<String> allowedExtensions;

  const FileUploadWidget({
    super.key,
    required this.onFileSelected,
    this.allowedExtensions = const ['csv', 'xlsx', 'xls'],
  });

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  bool _isDragging = false;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          widget.onFileSelected(file.name, file.bytes!);
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details) async {
        if (details.files.isEmpty) return;

        final file = details.files.first;
        final extension = file.name.split('.').last.toLowerCase();

        if (!widget.allowedExtensions.contains(extension)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('不支持的文件格式：$extension')),
          );
          return;
        }

        try {
          final bytes = await file.readAsBytes();
          widget.onFileSelected(file.name, bytes);
        } catch (e) {
          debugPrint('Error reading dropped file: $e');
        }
      },
      onDragEntered: (details) {
        setState(() => _isDragging = true);
      },
      onDragExited: (details) {
        setState(() => _isDragging = false);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _isDragging
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              icon: const Icon(Icons.upload_file),
              label: const Text('选择文件'),
              onPressed: _pickFile,
            ),
            const SizedBox(height: 8),
            Text(
              '或将文件拖放到这里',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}