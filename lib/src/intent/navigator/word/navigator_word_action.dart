part of intent;

class NavigatorWordAction extends Action<NavigatorWordIntent> {
  NavigatorWordAction(this.controller);
  final FimController controller;
  FimMode get mode => controller.mode;
  TextSelection get selection => controller.selection;
  int get caretOffset =>
      !mode.isVisual ? selection.baseOffset : selection.extentOffset;
  FimText get fimText => controller.fimText;
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
      word = word.next;
    }
    if (word == null) {
      return;
    }
    TextSelection tmpSelection;

    if (mode.isVisual) {
      tmpSelection = selection.copyWith(
        extentOffset: word.end,
      );
    } else {
      tmpSelection = TextSelection.collapsed(
        offset: word.end,
      );
    }
    _updateSelection(tmpSelection);
  }

  void _jumpBeforetHead() {
    FimWord? word =
        fimText.findWord(caretOffset) ?? fimText.findBeforeWord(caretOffset);
    if (word == null) {
      return;
    }
    if (word.start == caretOffset) {
      word = word.previous;
    }
    if (word == null) {
      return;
    }
    TextSelection tmpSelection;

    if (mode.isVisual) {
      tmpSelection = selection.copyWith(
        extentOffset: word.start,
      );
    } else {
      tmpSelection = TextSelection.collapsed(
        offset: word.start,
      );
    }
    _updateSelection(tmpSelection);
  }

  void _jumpNextHead() {
    FimWord? word = fimText.findNextWord(caretOffset);
    if (word == null) {
      return;
    }

    if (word.start == caretOffset) {
      word = word.next;
    }
    if (word == null) {
      return;
    }
    TextSelection tmpSelection;

    if (mode.isVisual) {
      tmpSelection = selection.copyWith(
        extentOffset: word.start,
      );
    } else {
      tmpSelection = TextSelection.collapsed(
        offset: word.start,
      );
    }
    _updateSelection(tmpSelection);
  }

  void _updateSelection(TextSelection selection) {
    controller.selection = selection;
  }
}
