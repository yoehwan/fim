import 'package:fim/fim.dart';
import 'package:fim/src/intent/direction/direction_intent.dart';
import 'package:flutter/material.dart';

class DirectionAction extends Action<DirectionIntent> {
  DirectionAction(this.controller);
  final FimController controller;
  TextSelection get selection => controller.selection;
  int get offset => selection.baseOffset;
  @override
  void invoke(DirectionIntent intent) {
    final direction = intent.direction;
    switch (direction) {
      case TraversalDirection.up:
        // TODO: Handle this case.
        break;
      case TraversalDirection.right:
        _right();
        break;
      case TraversalDirection.down:
        // TODO: Handle this case.
        break;
      case TraversalDirection.left:
        _left();
        break;
    }
  }

  void _left() {
    if (offset <= 0) {
      return;
    }
    controller.selection = selection.copyWith(
      baseOffset: offset - 1,
    );
  }

  void _right() {
    if (offset == controller.text.length) {
      return;
    }
    controller.selection = selection.copyWith(
      baseOffset: offset + 1,
    );
  }
}
