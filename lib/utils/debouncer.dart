// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;

  VoidCallback? action;
  Timer? _timer;
  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}