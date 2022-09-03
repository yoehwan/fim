part of intent;

class NewLineAction extends Action<NewLineIntent> {
  NewLineAction(this.controller);
  final FimController controller;
  @override
  void invoke(NewLineIntent intent) {
    final fimText = controller.fimText;
    final selection = controller.selection;
    final currentLine = fimText.findLine(selection.baseOffset);
    if (currentLine == null) {
      return;
    }

    final front = intent.front;
    final text = fimText.text;
    List<String> newText = text.characters.toList();
    final newOffset = front ? currentLine.end : currentLine.start;
    newText.insert(newOffset, "\n");
    controller.value = controller.value.copyWith(
      mode: FimMode.insert,
      fimText: FimText(text: newText.join()),
      selection:
          TextSelection.collapsed(offset: front ? newOffset + 1 : newOffset),
    );
  }
}
