part of intent;

class NavigatorArrowAction extends Action<NavigatorArrowIntent> {
  NavigatorArrowAction(this.controller);
  final FimController controller;
  int get offset => controller.offset;
  List<String> get lineList {
    return controller.text.split("\n");
  }

  int get currentLineIndex {
    final list = lineList;
    final listLen = list.length;
    final currentOffset = offset;
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
    final currentOffset = offset;
    final lineNumberIndex = currentLineIndex;
    final normalizedOffset = _computeNormalizedOffset(
      lineList: list,
      currentLineIndex: lineNumberIndex,
      currentOffset: currentOffset,
    );
    if (lineNumberIndex == 0) {
      controller.offset = 0;
      return;
    }
    final beforeLineTextLen = list[lineNumberIndex - 1].length;
    _updateOffset(currentOffset -
        normalizedOffset -
        beforeLineTextLen -
        1 +
        math.min(normalizedOffset, beforeLineTextLen));
  }

  void _down() {
    final list = lineList;
    final currentOffset = offset;
    final lineNumberIndex = currentLineIndex;
    final currentLineTextLen = list[lineNumberIndex].length;
    final normalizedOffset = _computeNormalizedOffset(
      lineList: list,
      currentLineIndex: lineNumberIndex,
      currentOffset: currentOffset,
    );
    if (lineNumberIndex == list.length - 1) {
      _updateOffset(controller.text.length);
      return;
    }
    final nextLineTextLen = list[lineNumberIndex + 1].length;
    _updateOffset(
      currentOffset -
          normalizedOffset +
          currentLineTextLen +
          1 +
          math.min(normalizedOffset, nextLineTextLen),
    );
  }

  void _left() {
    if (offset <= 0) {
      return;
    }
    _updateOffset(offset - 1);
  }

  void _right() {
    if (offset == controller.text.length) {
      return;
    }
    _updateOffset(offset + 1);
  }

  void _updateOffset(int offset) {
    controller.offset = offset;
  }
}
