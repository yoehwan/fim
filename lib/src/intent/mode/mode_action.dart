import 'package:fim/src/enum/mode.dart';
import 'package:fim/src/intent/mode/mode_intent.dart';
import 'package:flutter/material.dart';

class ModeAction extends Action<ModeIntent> {
  ModeAction(this.notifier);
  final ValueNotifier<FimMode> notifier;

  @override
  void invoke(ModeIntent intent) {
    notifier.value = intent.mode;
  }
}
