
// lib/core/hive_init.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/models.dart';

class HiveInit {
  static Future<void> init(String path) async {
    await Hive.initFlutter(path);

    // 注册适配器
    Hive.registerAdapter(DataSourceAdapter());
    Hive.registerAdapter(FieldAdapter());
    Hive.registerAdapter(DashboardAdapter());
    Hive.registerAdapter(ChartWidgetAdapter());

    // 打开数据库
    await Hive.openBox('dataSources');
    await Hive.openBox('dashboards');
  }
}