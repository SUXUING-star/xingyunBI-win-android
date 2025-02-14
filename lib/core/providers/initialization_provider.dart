// lib/core/providers/initialization_provider.dart
import 'package:flutter/material.dart';
import '../init/app_initialization.dart';

class InitializationProvider extends ChangeNotifier {
  String _message = "";
  double _progress = 0.0;
  bool _isInitialized = false;
  String? _error;

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
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
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