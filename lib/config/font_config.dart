// lib/core/config/font_config.dart
import 'dart:io';
import 'package:flutter/material.dart';

class FontConfig {
  // 默认字体
  static  String defaultFontFamily = Platform.isWindows ? 'Microsoft YaHei' : 'Roboto';

  // 字体回退列表
  static const List<String> fontFallback = [
    'Microsoft YaHei',  // Windows 中文字体
    'PingFang SC',      // macOS 中文字体
    'Noto Sans SC',     // 安卓中文字体
    'Source Han Sans CN', // 思源黑体
    'WenQuanYi Micro Hei', // Linux 中文字体
  ];

  // 获取适合当前平台的字体
  static String get platformFontFamily {
    if (Platform.isWindows) {
      return 'Microsoft YaHei';
    } else if (Platform.isMacOS) {
      return 'PingFang SC';
    } else if (Platform.isLinux) {
      return 'WenQuanYi Micro Hei';
    } else {
      return 'Roboto';
    }
  }
  // 获取字体主题数据
  static ThemeData getThemeWithFont(ThemeData baseTheme) {
    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontFamily: defaultFontFamily,
        fontFamilyFallback: fontFallback,
      ),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(
        fontFamily: defaultFontFamily,
        fontFamilyFallback: fontFallback,
      ),
    );
  }
}