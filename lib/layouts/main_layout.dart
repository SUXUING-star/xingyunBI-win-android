// lib/layouts/main_layout.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../layouts/background_layout.dart';
import '../config/font_config.dart';
import '../core/providers/initialization_provider.dart';
import '../services/update_service.dart';
import '../widgets/update/update_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';


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
    final ThemeData currentTheme = Theme.of(context);
    final ThemeData themeWithFont = FontConfig.getThemeWithFont(currentTheme);
    final isAndroid = Platform.isAndroid;

    // 设置更新回调
    context.read<InitializationProvider>().updateDialogCallback =
        (latestVersion, updateUrl, updateMessage, changelog) async {
      // 使用 package_info_plus 获取当前版本
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (context.mounted) {  // 确保 context 仍然有效
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => UpdateDialog(
            currentVersion: currentVersion,
            latestVersion: latestVersion ?? '未知',
            updateMessage: updateMessage,
            changelog: changelog,
            updateUrl: updateUrl,
          ),
        );
      }
    };



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
                  extended: !isAndroid, // 在非安卓设备上展开导航栏
                  minExtendedWidth: 150,
                  onDestinationSelected: (index) {
                    // 处理普通导航项
                    if (index < 3) {
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
                    }
                    // 处理检查更新按钮
                    else if (index == 3) {
                      context.read<InitializationProvider>().checkForUpdates(showNoUpdate: true);
                    }
                  },
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard, size: isAndroid ? 20 : 24),
                      label: Text('仪表盘', style: TextStyle(fontSize: isAndroid ? 12 : 14)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.storage, size: isAndroid ? 20 : 24),
                      label: Text('数据源', style: TextStyle(fontSize: isAndroid ? 12 : 14)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.info, size: isAndroid ? 20 : 24),
                      label: Text('关于', style: TextStyle(fontSize: isAndroid ? 12 : 14)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.system_update, size: isAndroid ? 20 : 24),
                      label: Text('检查更新', style: TextStyle(fontSize: isAndroid ? 12 : 14)),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Opacity(
                  opacity: 0.8,
                  child: Card(
                    margin: EdgeInsets.all(isAndroid ? 8 : 16),
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