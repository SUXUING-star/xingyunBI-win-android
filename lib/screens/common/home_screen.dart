// lib/screens/common/home_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/dashboard_list_card.dart';
import '../../widgets/home/data_source_list_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(),
            SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: DashboardListCard()),
                  SizedBox(width: 24),
                  Expanded(child: DataSourceListCard()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}