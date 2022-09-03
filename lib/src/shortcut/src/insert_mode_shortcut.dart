part of fim_shortcut;

  Map<ShortcutActivator, Intent> insertShortcuts(FimMode mode) {
    if (!mode.isInsert) {
      return {};
    }
    return {
      const SingleActivator(LogicalKeyboardKey.escape):
          const ModeIntent(FimMode.command),
    };
  }
