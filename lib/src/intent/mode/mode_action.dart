part of intent;

class ModeAction extends Action<ModeIntent> {
  ModeAction(this.controller);
  final FimController controller;
  @override
  void invoke(ModeIntent intent) {
    if (intent.after) {
      final selection = controller.selection;
      controller.selection = selection.copyWith(
        baseOffset: math.min(
          selection.baseOffset + 1,
          controller.text.length,
        ),
      );
    }
    controller.mode = intent.mode;
  }
}
