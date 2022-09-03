part of fim_shortcut;

Map<ShortcutActivator, Intent> visualShortcuts(FimMode mode) {
  if (!mode.isVisual) {
    return {};
  }
  return {
    const SingleActivator(LogicalKeyboardKey.escape):
        const ModeIntent(FimMode.command),
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
  };
}
