// lib/screens/common/about_screen.dart
import 'package:flutter/material.dart';
import '../../config/info.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.bar_chart,
        'title': '丰富的图表类型',
        'description': '支持柱状图、折线图、饼图等多种图表类型，满足不同的数据可视化需求。'
      },
      {
        'icon': Icons.storage,
        'title': '多样的数据源',
        'description': '支持CSV、JSON等多种数据格式，未来将支持更多数据源类型。'
      },
      {
        'icon': Icons.dashboard,
        'title': '灵活的布局',
        'description': '拖拽式布局设计，让您轻松创建富有表现力的数据仪表盘。'
      },
      {
        'icon': Icons.share,
        'title': '便捷的分享',
        'description': '一键导出和分享您的数据可视化作品，支持多种导出格式。'
      }
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header Section (20% height)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '关于 $siteName',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '跨平台数据可视化应用\n$siteDescription',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Features Section (45% height)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: Column(
              children: [
                Text(
                  '特色功能',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: features.map((feature) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(feature['icon'] as IconData, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              feature['title'] as String,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              feature['description'] as String,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Technologies Section (25% height)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Text(
                  '技术栈',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    'Flutter',
                    'Syncfusion Charts',
                    'Flutter UI',
                    'Hive DB',

                  ].map((tech) => Chip(
                    label: Text(tech),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  )).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.email),
                      label: Text(email),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      icon: const Icon(Icons.code),
                      label: Text(github),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}