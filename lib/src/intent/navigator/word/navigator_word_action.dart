part of intent;

class NavigatorWordAction extends Action<NavigatorWordIntent> {
  NavigatorWordAction(this.controller);
  final FimController controller;
  FimText get fimText => controller.fimText;
  int get caretOffset => controller.selection.baseOffset;
  @override
  void invoke(NavigatorWordIntent intent) {
    final front = intent.front;
    final position = intent.wordPostion;
    if (position.isTail) {
      _jumpTail();
    } else {
      if (front) {
        _jumpNextHead();
      } else {
        _jumpBeforetHead();
      }
    }
  }

  void _jumpTail() {
    FimWord? word =
        fimText.findWord(caretOffset) ?? fimText.findNextWord(caretOffset);
    if (word == null) {
      return;
    }
    if (word.end == caretOffset) {
      word = word.nextWord;
    }
    if (word == null) {
      return;
    }
    _updateOffset(word.end);
  }

  void _jumpBeforetHead() {
    FimWord? word =
        fimText.findWord(caretOffset) ?? fimText.findBeforeWord(caretOffset);
    if (word == null) {
      return;
    }
    if (word.start == caretOffset) {
      word = word.beforeWord;
    }
    if (word == null) {
      return;
    }
    _updateOffset(word.start);
  }

  void _jumpNextHead() {
    FimWord? word = fimText.findNextWord(caretOffset);
    if (word == null) {
      return;
    }

    if (word.start == caretOffset) {
      word = word.nextWord;
    }
    if (word == null) {
      return;
    }
    _updateOffset(word.start);
  }

  void _updateOffset(int offset) {
    controller.selection = controller.selection.copyWith(baseOffset: offset);
  }
}
