part of intent;
class ModeAction extends Action<ModeIntent> {
  ModeAction(this.notifier);
  final ValueNotifier<FimMode> notifier;

  @override
  void invoke(ModeIntent intent) {
    notifier.value = intent.mode;
  }
}
