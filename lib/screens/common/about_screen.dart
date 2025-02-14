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

    ];

    return Scaffold(
      body: SingleChildScrollView( // 添加滚动支持
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header Section
              Text(
                '关于 $siteName',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                '$siteDescription',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Features Section
              Text(
                '特色功能',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),

              GridView.count(
                shrinkWrap: true, // 使 GridView 适应内容
                physics: const NeverScrollableScrollPhysics(), // 禁用 GridView 自身的滚动
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
                          const SizedBox(height: 4),
                          Text(
                            feature['title'] as String,
                            style: Theme.of(context).textTheme.titleSmall,
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

              const SizedBox(height: 32),

              // Technologies Section
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
      ),
    );
  }
}