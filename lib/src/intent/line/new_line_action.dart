part of intent;

class NewLineAction extends Action<NewLineIntent> {
  NewLineAction(this.controller);
  final FimController controller;
  TextSelection get selection => controller.selection;
  @override
  void invoke(NewLineIntent intent) {
    final text = controller.fimText;
    final currentLine = text.findLine(selection.baseOffset);
    if (currentLine == null) {
      return;
    }

  // todo: fix insert char & move caret
    if (intent.front) {
      controller.insertChar(currentLine.end, "\n");
    } else {
      controller.insertChar(currentLine.start, "\n");
    }
    controller.mode = FimMode.insert;
  }
}
