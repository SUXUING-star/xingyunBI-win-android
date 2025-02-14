// lib/core/init/app_initialization.dart
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/models.dart';

class AppInitialization {
  static Future<void> initializeApp(
      void Function(String, double) onProgress) async {
    try {
      onProgress("正在初始化存储...", 0.2);
      final appDocumentDir = await getApplicationDocumentsDirectory();

// 初始化 Hive
      onProgress("正在初始化数据库...", 0.4);
      await Hive.initFlutter(appDocumentDir.path);

// 注册适配器
      onProgress("正在注册数据模型...", 0.6);
      if (!Hive.isAdapterRegistered(0)) {
        // 检查是否已注册
        Hive.registerAdapter(DataSourceAdapter());
        Hive.registerAdapter(FieldAdapter());
        Hive.registerAdapter(DashboardAdapter());
        Hive.registerAdapter(ChartWidgetAdapter());
      }

// 打开数据库
      onProgress("正在打开数据库...", 0.8);
      await Future.wait([
        Hive.openBox('dataSources'),
        Hive.openBox('dashboards'),
      ]);

      onProgress("初始化完成", 1.0);
    } catch (e) {
      throw InitializationException("初始化失败: $e");
    }
  }
}

class InitializationException implements Exception {
  final String message;
  InitializationException(this.message);

  @override
  String toString() => message;
}
