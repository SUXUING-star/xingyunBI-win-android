// lib/layouts/main_layout.dart
import 'package:flutter/material.dart';
import '../layouts/background_layout.dart';
import '../config/font_config.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    // 获取当前主题并应用字体配置
    final ThemeData currentTheme = Theme.of(context);
    final ThemeData themeWithFont = FontConfig.getThemeWithFont(currentTheme);

    return Theme(
      data: themeWithFont,
      child: BackgroundLayout(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              Opacity(
                opacity: 0.8,
                child: NavigationRail(
                  selectedIndex: _getSelectedIndex(currentPath),
                  onDestinationSelected: (index) {
                    switch (index) {
                      case 0:
                        if (currentPath != '/') {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                        break;
                      case 1:
                        if (currentPath != '/datasources') {
                          Navigator.pushReplacementNamed(context, '/datasources');
                        }
                        break;
                      case 2:
                        if (currentPath != '/about') {
                          Navigator.pushReplacementNamed(context, '/about');
                        }
                        break;
                    }
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard),
                      label: Text('仪表盘'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.storage),
                      label: Text('数据源'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.info),
                      label: Text('关于'),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Opacity(
                  opacity: 0.8,
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getSelectedIndex(String path) {
    switch (path) {
      case '/':
        return 0;
      case '/datasources':
        return 1;
      case '/about':
        return 2;
      default:
        return 0;
    }
  }
}