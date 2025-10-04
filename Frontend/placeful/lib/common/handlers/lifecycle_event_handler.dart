import 'dart:async';

import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  void Function(AppLifecycleState)? onLifecycleChange;

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    onLifecycleChange?.call(state);
  }
}
