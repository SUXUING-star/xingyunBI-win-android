// lib/core/providers/initialization_provider.dart
import 'package:flutter/material.dart';
import '../init/app_initialization.dart';
import '../../services/update_service.dart';

class InitializationProvider extends ChangeNotifier {
  String _message = "";
  double _progress = 0.0;
  bool _isInitialized = false;
  String? _error;
  final UpdateService _updateService = UpdateService();

  // 更新相关回调
  Function(String?, String?, String?, List<String>?)? updateDialogCallback;
  Function()? noUpdateCallback;
  Function(String)? updateErrorCallback;

  String get message => _message;
  double get progress => _progress;
  bool get isInitialized => _isInitialized;
  String? get error => _error;

  Future<void> startInitialization() async {
    try {
      _error = null;
      await AppInitialization.initializeApp((message, progress) {
        _message = message;
        _progress = progress;
        notifyListeners();
      });
      _isInitialized = true;

      // 初始化完成后自动检查更新
      await checkForUpdates(showNoUpdate: false);
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> checkForUpdates({bool showNoUpdate = false}) async {
    try {
      await _updateService.checkForUpdates();

      if (_updateService.updateAvailable && updateDialogCallback != null) {
        // 有新版本时显示更新对话框
        updateDialogCallback!.call(
          _updateService.latestVersion,
          _updateService.updateUrl,
          _updateService.updateMessage,
          _updateService.changelog,
        );
      } else if (showNoUpdate && noUpdateCallback != null) {
        // 手动检查且无更新时显示提示
        noUpdateCallback!.call();
      }
    } catch (e) {
      // 检查更新失败时的错误处理
      if (showNoUpdate && updateErrorCallback != null) {
        updateErrorCallback!.call(e.toString());
      } else {
        debugPrint('自动检查更新失败: $e');
      }
    }
  }

  void reset() {
    _message = "";
    _progress = 0.0;
    _isInitialized = false;
    _error = null;
    notifyListeners();
  }
}