// lib/core/chart_data_processor.dart
import '../../../models/models.dart';

class ChartData {
  final String dimension;
  final Map<String, num> values;

  ChartData(this.dimension, this.values);
}

class ChartDataProcessor {
  List<ChartData> processData(
      List<Map<String, dynamic>> records,
      List<Field> dimensions,
      List<Field> measures,
      ) {
    // 确保至少有一个维度和度量
    if (dimensions.isEmpty || measures.isEmpty) {
      throw Exception('需要至少一个维度和一个度量');
    }

    // 按维度分组
    final groupedData = <String, Map<String, num>>{};

    for (final record in records) {
      // 生成维度值（如果多个维度，用 - 连接）
      final dimensionValue = dimensions
          .map((d) => record[d.name]?.toString() ?? '')
          .join(' - ');

      // 初始化或获取该维度的数据
      final values = groupedData[dimensionValue] ?? {};

      // 计算每个度量的值
      for (final measure in measures) {
        final value = record[measure.name];
        if (value != null) {
          final numValue = (value is num)
              ? value
              : num.tryParse(value.toString()) ?? 0;

          values[measure.name] = (values[measure.name] ?? 0) + numValue;
        }
      }

      groupedData[dimensionValue] = values;
    }

    // 转换为列表格式
    return groupedData.entries
        .map((e) => ChartData(e.key, e.value))
        .toList();
  }
}