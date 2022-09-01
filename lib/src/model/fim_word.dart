part of fim_text;

class FimWord {
  FimWord({
    required this.start,
    required this.data,
    this.nextWord,
    this.beforeWord,
  });
  factory FimWord.empty() {
    return FimWord(
      start: 0,
      data: "",
    );
  }

  final int start;
  int get end => start + data.length - 1;
  String data;
  FimWord? nextWord;
  FimWord? beforeWord;

  bool get hasNext => nextWord != null;
  bool get hasBefore => beforeWord != null;
  bool get isEmpty => data.isEmpty;
  void add(FimWord word) {
    last().nextWord = word;
  }

  FimWord last() {
    FimWord word = this;
    while (word.hasNext) {
      word = word.nextWord!;
    }
    return word;
  }

  bool containOffset(int offset) {
    return start <= offset && offset <= end;
  }

  Map<String, dynamic> toMap() {
    return {
      "start": start,
      "end": end,
      "data": data,
      "nextWord": nextWord,
      "beforeWord": beforeWord,
    };
  }
}
