part of fim_shortcut;

Map<ShortcutActivator, Intent> defaultShortcuts() {
  return {
    // Direction
    const SingleActivator(LogicalKeyboardKey.arrowLeft):
        const NavigatorArrowIntent(TraversalDirection.left),
    const SingleActivator(LogicalKeyboardKey.arrowRight):
        const NavigatorArrowIntent(TraversalDirection.right),
    const SingleActivator(LogicalKeyboardKey.arrowDown):
        const NavigatorArrowIntent(TraversalDirection.down),
    const SingleActivator(LogicalKeyboardKey.arrowUp):
        const NavigatorArrowIntent(TraversalDirection.up),
  };
}
