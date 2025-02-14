// lib/widgets/home/home_header.dart
import 'package:flutter/material.dart';
import 'dart:io';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    final screenWidth = MediaQuery.of(context).size.width;

    // 根据平台和屏幕宽度调整内边距
    final horizontalPadding = isAndroid
        ? (screenWidth < 600 ? 12.0 : 16.0)
        : 24.0;
    final verticalPadding = isAndroid
        ? (screenWidth < 600 ? 8.0 : 12.0)
        : 16.0;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '我的仪表盘',
                    style: isAndroid && screenWidth < 600
                        ? Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )
                        : Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isAndroid || screenWidth >= 600) ...[
                    const SizedBox(height: 8),
                    Text(
                      '创建并管理您的数据可视化仪表盘',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: isAndroid && screenWidth < 600
                ? IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            )
                : FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('新建仪表盘'),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
          ),
        ],
      ),
    );
  }
}