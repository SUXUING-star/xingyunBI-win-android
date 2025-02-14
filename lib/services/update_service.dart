// lib/services/update_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import '../config/info.dart';  // 使用已有的 info.dart

class UpdateService extends ChangeNotifier {
  bool _isChecking = false;
  String? _latestVersion;
  String? _currentVersion;
  String? _updateUrl;
  bool _updateAvailable = false;
  bool _forceUpdate = false;
  String? _updateMessage;
  List<String>? _changelog;

  bool get isChecking => _isChecking;
  bool get updateAvailable => _updateAvailable;
  bool get forceUpdate => _forceUpdate;
  String? get latestVersion => _latestVersion;
  String? get updateUrl => _updateUrl;
  String? get updateMessage => _updateMessage;
  List<String>? get changelog => _changelog;

  Future<void> checkForUpdates() async {
    if (_isChecking) return;

    try {
      _isChecking = true;
      notifyListeners();

      // 获取当前版本
      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;
      debugPrint("当前版本: $_currentVersion");

      // 从 github 变量获取用户名
      final githubName = github;  // 从 info.dart 获取
      final repoName = githubRepo;  // 仓库名称

      // 检查 GitHub Release
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/$githubName/$repoName/releases/latest'),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'xingyunBI-app'  // 添加 User-Agent
        },
      ).timeout(
        const Duration(seconds: 15),  // 增加超时时间
        onTimeout: () {
          throw Exception('请求超时，请检查网络连接');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _latestVersion = data['tag_name'].toString().replaceAll('v', '');
        _updateUrl = data['html_url'];

        // 解析 body 中的自定义字段
        final body = data['body'] as String? ?? '';

        // 解析强制更新标记
        final forceUpdateMatch = RegExp(r'\[force_update:\s*(true|false)\]')
            .firstMatch(body);
        _forceUpdate = forceUpdateMatch?.group(1) == 'true';

        // 解析更新消息
        final messageMatch = RegExp(r'\[update_message:\s*(.*?)\]')
            .firstMatch(body);
        _updateMessage = messageMatch?.group(1)?.trim();

        // 解析更新日志
        final changelogMatch = RegExp(r'\[changelog\]([\s\S]*?)\[/changelog\]')
            .firstMatch(body);
        if (changelogMatch != null) {
          _changelog = changelogMatch.group(1)
              ?.split('\n')
              .map((line) => line.trim())
              .where((line) => line.startsWith('-'))
              .map((line) => line.substring(1).trim())
              .toList();
        }

        debugPrint("最新版本: $_latestVersion");
        // 比较版本号
        _updateAvailable = _compareVersions(_currentVersion!, _latestVersion!);
      } else if (response.statusCode == 403) {
        throw Exception('API 请求次数超限，请稍后再试');
      } else {
        throw Exception('服务器返回错误: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('检查更新失败: $e');
      rethrow;  // 继续抛出异常以便上层处理
    } finally {
      _isChecking = false;
      notifyListeners();
    }
  }

  bool _compareVersions(String current, String latest) {
    try {
      List<int> currentParts = current.split('.').map(int.parse).toList();
      List<int> latestParts = latest.split('.').map(int.parse).toList();

      // 确保两个版本号列表长度相同
      while (currentParts.length < 3) currentParts.add(0);
      while (latestParts.length < 3) latestParts.add(0);

      for (int i = 0; i < 3; i++) {
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }
      return false;
    } catch (e) {
      debugPrint('版本号比较错误: $e');
      return false;
    }
  }
}