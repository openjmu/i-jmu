///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/5/25 16:57
///
import 'package:flutter/widgets.dart';

class BaseChangeNotifier extends ChangeNotifier {
  bool _mounted = true;

  bool get mounted => _mounted;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_mounted) {
      return;
    }
    super.notifyListeners();
  }
}

class BaseValueNotifier<T> extends ValueNotifier<T> {
  BaseValueNotifier(T value) : super(value);

  bool _mounted = true;

  bool get mounted => _mounted;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_mounted) {
      return;
    }
    super.notifyListeners();
  }
}