part of intent;

class NavigatorArrowAction extends Action<NavigatorArrowIntent> {
  NavigatorArrowAction(this.controller);
  final FimController controller;
  TextSelection get selection => controller.selection;
  FimMode get mode => controller.mode;
  String get text => controller.text;
  List<String> get lineList {
    return text.split("\n");
  }

  int get currentLineIndex {
    final list = lineList;
    final listLen = list.length;
    final currentOffset = selection.baseOffset;
    int total = 0;
    for (int index = 0; index < listLen; index++) {
      final text = list[index];
      total += text.length;
      if (total + index >= currentOffset) {
        return index;
      }
    }
    return list.length - 1;
  }

  @override
  void invoke(NavigatorArrowIntent intent) {
    final direction = intent.direction;
    switch (direction) {
      case TraversalDirection.up:
        _up();
        break;
      case TraversalDirection.right:
        _right();
        break;
      case TraversalDirection.down:
        _down();
        break;
      case TraversalDirection.left:
        _left();
        break;
    }
  }

  int _computeNormalizedOffset({
    required List<String> lineList,
    required int currentLineIndex,
    required int currentOffset,
  }) {
    final textLen = lineList.sublist(0, currentLineIndex).join("").length;
    return currentOffset - textLen - currentLineIndex;
  }

  void _up() {
    final list = lineList;
    final currentOffset = selection;
    final lineNumberIndex = currentLineIndex;
    final normalizedOffset = _computeNormalizedOffset(
      lineList: list,
      currentLineIndex: lineNumberIndex,
      currentOffset: selection.baseOffset,
    );
    if (lineNumberIndex == 0) {
      controller.selection = const TextSelection.collapsed(offset: 0);
      return;
    }
    final beforeLineTextLen = list[lineNumberIndex - 1].length;
    final int newOffset = currentOffset.baseOffset -
        normalizedOffset -
        beforeLineTextLen -
        1 +
        math.min(normalizedOffset, beforeLineTextLen);
    _updateSelection(TextSelection.collapsed(offset: newOffset));
  }

  void _down() {
    final list = lineList;
    final currentOffset = selection;
    final lineNumberIndex = currentLineIndex;
    final currentLineTextLen = list[lineNumberIndex].length;
    final normalizedOffset = _computeNormalizedOffset(
      lineList: list,
      currentLineIndex: lineNumberIndex,
      currentOffset: currentOffset.baseOffset,
    );
    if (lineNumberIndex == list.length - 1) {
      _updateSelection(
        selection.copyWith(
          baseOffset: text.length,
        ),
      );
      return;
    }
    final nextLineTextLen = list[lineNumberIndex + 1].length;
    final int newOffset = currentOffset.baseOffset -
        normalizedOffset +
        currentLineTextLen +
        1 +
        math.min(normalizedOffset, nextLineTextLen);
    _updateSelection(TextSelection.collapsed(offset: newOffset));
  }

  void _left() {
    final baseOffset = selection.baseOffset;
    final extentOffset = selection.extentOffset;
    if (baseOffset <= 0) {
      return;
    }
    TextSelection tmpSelection;

    if (mode.isVisual) {
      tmpSelection = selection.copyWith(
        extentOffset: extentOffset - 1,
      );
    } else {
      tmpSelection = TextSelection.collapsed(
        offset: baseOffset - 1,
      );
    }
    _updateSelection(tmpSelection);
  }

  void _right() {
    final baseOffset = selection.baseOffset;
    final extentOffset = selection.extentOffset;
    if (baseOffset >= text.length || extentOffset >= text.length) {
      return;
    }
    TextSelection tmpSelection;
    if (mode.isVisual) {
      tmpSelection = selection.copyWith(
        extentOffset: extentOffset + 1,
      );
    } else {
      tmpSelection = TextSelection.collapsed(
        offset: baseOffset + 1,
      );
    }
    _updateSelection(tmpSelection);
  }

  void _updateSelection(TextSelection selection) {
    controller.selection = selection;
  }
}
