part of intent;

class ModeAction extends Action<ModeIntent> {
  ModeAction(this.controller);
  final FimController controller;
  @override
  void invoke(ModeIntent intent) {
    controller.mode = intent.mode;
  }
}
