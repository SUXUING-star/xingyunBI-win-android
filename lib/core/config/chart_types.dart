// lib/core/config/chart_types.dart
enum ChartType {
  bar,
  line,
  pie,
  area,
  scatter,
  radar,
  heatmap,
  bubble,
  waterfall,
  boxplot; // Added boxplot

  String get label {
    switch (this) {
      case ChartType.bar:
        return '柱状图';
      case ChartType.line:
        return '折线图';
      case ChartType.pie:
        return '饼图';
      case ChartType.area:
        return '面积图';
      case ChartType.scatter:
        return '散点图';
      case ChartType.radar:
        return '雷达图';
      case ChartType.heatmap:
        return '热力图';
      case ChartType.bubble:
        return '气泡图';
      case ChartType.waterfall:
        return '瀑布图';
      case ChartType.boxplot: // Added boxplot label
        return '箱线图';
    }
  }
}

enum ChartOptionType {
  title,
  legend,
  tooltip,
  dataLabel,
  stack,
  direction,
  smooth,
  area,
  roseType,
  regression;

  String get label {
    switch (this) {
      case ChartOptionType.title:
        return '标题';
      case ChartOptionType.legend:
        return '图例';
      case ChartOptionType.tooltip:
        return '提示';
      case ChartOptionType.dataLabel:
        return '标签';
      case ChartOptionType.stack:
        return '堆叠';
      case ChartOptionType.direction:
        return '方向';
      case ChartOptionType.smooth:
        return '平滑';
      case ChartOptionType.area:
        return '面积';
      case ChartOptionType.roseType:
        return '南丁格尔玫瑰';
      case ChartOptionType.regression:
        return '回归线';
    }
  }
}

class ChartTypeConfig {
  final ChartType type;
  final List<ChartOptionType> supportedOptions;
  final int maxDimensions;
  final int maxMeasures;

  const ChartTypeConfig({
    required this.type,
    required this.supportedOptions,
    this.maxDimensions = 1,
    this.maxMeasures = 5,
  });
}

final chartConfigs = {
  ChartType.bar: ChartTypeConfig(
    type: ChartType.bar,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
      ChartOptionType.dataLabel,
      ChartOptionType.stack,
      ChartOptionType.direction,
    ],
    maxDimensions: 1,
    maxMeasures: 10,
  ),
  ChartType.line: ChartTypeConfig(
    type: ChartType.line,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
      ChartOptionType.dataLabel,
      ChartOptionType.smooth,
      ChartOptionType.area,
    ],
  ),
  ChartType.pie: ChartTypeConfig(
    type: ChartType.pie,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
      ChartOptionType.dataLabel,
      ChartOptionType.roseType,
    ],
    maxDimensions: 1,
    maxMeasures: 1,
  ),
  ChartType.scatter: ChartTypeConfig( // Add this
    type: ChartType.scatter,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
      ChartOptionType.dataLabel,
    ],
    maxDimensions: 1,
    maxMeasures: 3, // Adjust based on how many measures you want for size/color
  ),
  ChartType.radar: ChartTypeConfig(  // Add this
    type: ChartType.radar,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
      ChartOptionType.dataLabel,
    ],
    maxDimensions: 1,
    maxMeasures: 5, // Adjust based on number of radar axes
  ),
  ChartType.heatmap: ChartTypeConfig( // Add this
    type: ChartType.heatmap,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
    ],
    maxDimensions: 2, // Usually X and Y
    maxMeasures: 1, // The value for the heatmap
  ),
  ChartType.bubble: ChartTypeConfig( // 新增气泡图的配置
    type: ChartType.bubble,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
      ChartOptionType.dataLabel,
    ],
    maxDimensions: 1,
    maxMeasures: 3, // 至少需要两个度量 (x, y, size)，可以加颜色
  ),
  ChartType.waterfall: ChartTypeConfig( // 新增瀑布图的配置
    type: ChartType.waterfall,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
      ChartOptionType.dataLabel,
    ],
    maxDimensions: 1,
    maxMeasures: 1,
  ),
  ChartType.boxplot: ChartTypeConfig( // Add boxplot config
    type: ChartType.boxplot,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
      ChartOptionType.dataLabel,
    ],
    maxDimensions: 1, // Typically one dimension (category)
    maxMeasures: 5,   // Min, Q1, Median, Q3, Max.  Can vary depending on outliers.
  ),
  ChartType.area: ChartTypeConfig(
    type: ChartType.area,
    supportedOptions: [
      ChartOptionType.title,
      ChartOptionType.legend,
      ChartOptionType.tooltip,
      ChartOptionType.dataLabel,
      ChartOptionType.smooth,
    ],
    maxDimensions: 1,
    maxMeasures: 5,
  ),
};