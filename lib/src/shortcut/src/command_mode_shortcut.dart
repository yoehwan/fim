part of fim_shortcut;

Map<ShortcutActivator, Intent> commandShortcuts(FimMode mode) {
  if (!mode.isCommand) {
    return {};
  }
  return {
    const SingleActivator(LogicalKeyboardKey.keyA):
        const ModeIntent(FimMode.insert, after: true),
    const SingleActivator(LogicalKeyboardKey.keyI):
        const ModeIntent(FimMode.insert),
    const SingleActivator(LogicalKeyboardKey.keyV):
        const ModeIntent(FimMode.visual),
    // Direction
    const SingleActivator(LogicalKeyboardKey.keyH):
        const NavigatorArrowIntent(TraversalDirection.left),
    const SingleActivator(LogicalKeyboardKey.keyL):
        const NavigatorArrowIntent(TraversalDirection.right),
    const SingleActivator(LogicalKeyboardKey.keyJ):
        const NavigatorArrowIntent(TraversalDirection.down),
    const SingleActivator(LogicalKeyboardKey.keyK):
        const NavigatorArrowIntent(TraversalDirection.up),

    // Navigator
    const SingleActivator(LogicalKeyboardKey.keyE):
        const NavigatorWordIntent(front: true, wordPostion: WordPostion.tail),
    const SingleActivator(LogicalKeyboardKey.keyW):
        const NavigatorWordIntent(front: true, wordPostion: WordPostion.head),
    const SingleActivator(LogicalKeyboardKey.keyB):
        const NavigatorWordIntent(front: false, wordPostion: WordPostion.head),

    // Line
    const SingleActivator(LogicalKeyboardKey.keyO):
        const NewLineIntent(front: true),
    const SingleActivator(LogicalKeyboardKey.keyO, shift: true):
        const NewLineIntent(front: false)
  };
}
