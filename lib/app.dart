// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show exit;
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'core/providers/initialization_provider.dart';
import 'widgets/startup/initialization_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '星云BI',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        return Consumer<InitializationProvider>(
          builder: (context, initProvider, _) {
            // 启动初始化流程
            if (!initProvider.isInitialized && initProvider.error == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                initProvider.startInitialization();
              });
            }

            // 显示初始化界面或主应用路由
            return initProvider.isInitialized
                ? (child ?? const SizedBox()) // 使用路由系统提供的 child
                : InitializationView(
              status: initProvider.error != null
                  ? InitializationStatus.error
                  : InitializationStatus.inProgress,
              message: initProvider.error ?? initProvider.message,
              progress: initProvider.progress,
              onRetry: initProvider.error != null
                  ? () => initProvider.startInitialization()
                  : null,
              onExit: () => exit(0),
            );
          },
        );
      },
    );
  }
}