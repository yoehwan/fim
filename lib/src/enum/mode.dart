enum FimMode {
  command,
  insert,
}

extension FimModeExtension on FimMode {
  bool get isCommand => this == FimMode.command;
  bool get isInsert => this == FimMode.insert;
}
