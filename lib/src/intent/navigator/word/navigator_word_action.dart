part of intent;

class NavigatorWordAction extends Action<NavigatorWordIntent> {
  NavigatorWordAction(this.controller);
  final FimController controller;
  FimText get fimText => controller.fimText;
  int get offset => controller.offset;
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
    FimWord? word = fimText.findWord(offset) ?? fimText.findNextWord(offset);
    if (word == null) {
      return;
    }
    if (word.end == offset) {
      word = word.nextWord;
    }
    if (word == null) {
      return;
    }
    _updateOffset(word.end);
  }

  void _jumpBeforetHead() {
    FimWord? word = fimText.findWord(offset) ?? fimText.findBeforeWord(offset);
    if (word == null) {
      return;
    }
    if (word.start == offset) {
      word = word.beforeWord;
    }
    if (word == null) {
      return;
    }
    _updateOffset(word.start);
  }

  void _jumpNextHead() {
    FimWord? word = fimText.findNextWord(offset);
    if (word == null) {
      return;
    }

    if (word.start == offset) {
      word = word.nextWord;
    }
    if (word == null) {
      return;
    }
    _updateOffset(word.start);
  }

  void _updateOffset(int offset) {
    controller.offset = offset;
  }
}
