// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'app.dart';
import 'core/providers/initialization_provider.dart';
import 'services/update_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置安卓横屏模式
  if (Platform.isAndroid) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // 可选：设置全屏模式
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  // 桌面平台窗口设置
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      center: true,
      title: "星云BI",
      minimumSize: Size(800, 600),
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UpdateService()),
        ChangeNotifierProvider(create: (_) => InitializationProvider()),
      ],
      child: const App(),
    ),
  );
}

