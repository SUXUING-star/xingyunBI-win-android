// lib/models/models.dart
import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class DataSource extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final List<Field> fields;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final List<Map<String, dynamic>> records;

  DataSource({
    required this.id,
    required this.name,
    required this.type,
    required this.fields,
    required this.createdAt,
    required this.records,
  });
}

@HiveType(typeId: 1)
class Field extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final bool isNumeric;

  @HiveField(3)
  final bool isDate;

  Field({
    required this.name,
    required this.type,
    required this.isNumeric,
    required this.isDate,
  });
}

@HiveType(typeId: 2)
class Dashboard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<ChartWidget> charts;

  @HiveField(3)
  final Map<String, dynamic> layout;

  Dashboard({
    required this.id,
    required this.name,
    required this.charts,
    required this.layout,
  });
}

@HiveType(typeId: 3)
class ChartWidget extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final List<Field> dimensions;

  @HiveField(4)
  final List<Field> measures;

  @HiveField(5)
  final Map<String, dynamic> settings;

  @HiveField(6)  // 添加数据源字段
  final DataSource dataSource;

  ChartWidget({
    required this.id,
    required this.name,
    required this.type,
    required this.dimensions,
    required this.measures,
    required this.settings,
    required this.dataSource
  });
}