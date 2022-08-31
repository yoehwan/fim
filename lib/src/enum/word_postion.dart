enum WordPostion {
  head,
  tail,
}

extension WordPostionExtension on WordPostion {
  bool get isHead => this == WordPostion.head;
  bool get isTail => this == WordPostion.tail;
}
