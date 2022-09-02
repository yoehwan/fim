enum FimMode {
  command,
  insert,
  visual,
}

extension FimModeExtension on FimMode {
  bool get isCommand => this == FimMode.command;
  bool get isInsert => this == FimMode.insert;
  bool get isVisual => this == FimMode.visual;
}
