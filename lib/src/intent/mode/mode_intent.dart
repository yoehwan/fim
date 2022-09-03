part of intent;

class ModeIntent extends Intent {
  const ModeIntent(
    this.mode, {
    this.after = false,
  });
  final FimMode mode;
  final bool after;
}
