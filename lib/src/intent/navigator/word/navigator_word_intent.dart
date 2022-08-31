part of intent;

class NavigatorWordIntent extends Intent {
  const NavigatorWordIntent({
    required this.front,
    required this.wordPostion,
  });
  final bool front;
  final WordPostion wordPostion;

}
