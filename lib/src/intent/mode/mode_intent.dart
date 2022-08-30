import 'package:fim/fim.dart';
import 'package:flutter/material.dart';

abstract class ModeIntent extends Intent {
  const ModeIntent();
  FimMode get mode;
}

class CommandModeIntent extends ModeIntent {
  const CommandModeIntent();
  @override
  FimMode get mode => FimMode.command;
}

class InsertModeIntent extends ModeIntent {
  const InsertModeIntent();
  @override
  FimMode get mode => FimMode.insert;
}
