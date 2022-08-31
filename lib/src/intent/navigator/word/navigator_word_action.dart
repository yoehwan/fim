part of intent;

class NavigatorWordAction extends Action<NavigatorWordIntent> {
  NavigatorWordAction(this.controller);
  final FimController controller;
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

  void _jumpTail([int? caretOffset]) {
    final int offset = caretOffset ?? controller.selection.baseOffset;
    final text = controller.text;
    final fimText = FimText(text);
    FimWord? word = fimText.findWord(offset);
    if (word == null) {
      return;
    }
    if (word.end - 1 == offset) {
      word = word.nextWord;
    }
    if (word == null) {
      return;
    }
    controller.selection = controller.selection.copyWith(
      baseOffset: word.end - 1,
    );
  }

  void _jumpBeforetHead([int? caretOffset]) {
    final int offset = caretOffset ?? controller.selection.baseOffset;
    final text = controller.text;
    final fimText = FimText(text);
    FimWord? word = fimText.findWord(offset);
    if (word == null) {
      return;
    }
    if (word.start == offset) {
      word = word.beforeWord;
    }
    if (word == null) {
      return;
    }
    controller.selection = controller.selection.copyWith(
      baseOffset: word.start,
    );
  }

  void _jumpNextHead([int? caretOffset]) {
    final int offset = caretOffset ?? controller.selection.baseOffset;
    final text = controller.text;
    final fimText = FimText(text);
    FimWord? word = fimText.findWord(offset);
    if (word == null) {
      return;
    }
    word = word.nextWord;
    if (word == null) {
      return;
    }
    controller.selection = controller.selection.copyWith(
      baseOffset: word.start,
    );
  }
}
