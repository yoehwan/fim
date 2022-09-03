part of fim_text;

class FimWord extends LinkedListEntry<FimWord> with EquatableMixin {
  FimWord({
    required this.line,
    required this.start,
    required this.data,
  });
  factory FimWord.empty() {
    return FimWord(
      line: 0,
      start: 0,
      data: "",
    );
  }

  final int line;
  final int start;
  int get end => start + data.length - 1;
  final String data;

  bool containOffset(int offset) {
    return start <= offset && offset <= end;
  }

  Map<String, dynamic> toMap() {
    return {
      "start": start,
      "end": end,
      "data": data,
    };
  }

  @override
  List<Object?> get props => [start, end, data];
}
