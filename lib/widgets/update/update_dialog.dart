// lib/widgets/update/update_dialog.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String latestVersion;
  final String? updateMessage;
  final List<String>? changelog;
  final String? updateUrl;

  const UpdateDialog({
    super.key,
    required this.currentVersion,
    required this.latestVersion,
    this.updateMessage,
    this.changelog,
    this.updateUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;

    return AlertDialog(
      title: Text(
        '发现新版本',
        style: TextStyle(
          fontSize: isAndroid ? 16 : 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('当前版本：$currentVersion'),
          Text('最新版本：$latestVersion'),
          if (updateMessage != null) ...[
            const SizedBox(height: 16),
            Text(updateMessage!),
          ],
          if (changelog != null && changelog!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('更新内容：'),
            ...changelog!.map((log) => Text('• $log')),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('稍后再说'),
        ),
        FilledButton(
          onPressed: () async {
            if (updateUrl != null) {
              final uri = Uri.parse(updateUrl!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            }
            Navigator.of(context).pop();
          },
          child: const Text('立即更新'),
        ),
      ],
    );
  }
}