import 'package:flutter/material.dart';
import 'dart:io';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/dashboard_list_card.dart';
import '../../widgets/home/data_source_list_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取屏幕尺寸
    final screenSize = MediaQuery.of(context).size;

    // 根据平台和屏幕大小调整内边距
    final padding = Platform.isAndroid
        ? (screenSize.width < 600 ? 12.0 : 16.0)
        : 24.0;

    // 根据平台调整卡片之间的间距
    final cardSpacing = Platform.isAndroid
        ? (screenSize.width < 600 ? 12.0 : 16.0)
        : 24.0;

    // 根据平台调整布局比例
    final dashboardFlex = Platform.isAndroid
        ? (screenSize.width < 600 ? 3 : 2)
        : 2;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            SizedBox(height: cardSpacing),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: dashboardFlex,
                      child: const DashboardListCard()
                  ),
                  SizedBox(width: cardSpacing),
                  const Expanded(child: DataSourceListCard()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
