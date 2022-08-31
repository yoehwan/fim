class FimText {
  FimText(String text) {
    int currentOffset = 0;
    FimWord beforeWord = fimWord;
    final lineList = text.split("\n");
    for (final line in lineList) {
      final words = line.split(" ");
      for (final word in words) {
        if (word.trim().isNotEmpty) {
          final tmpWord = FimWord(
            start: currentOffset,
            data: word,
            beforeWord: beforeWord,
          );
          fimWord.add(tmpWord);
          beforeWord = tmpWord;
          currentOffset = tmpWord.end + 1;
        } else {
          currentOffset++;
        }
      }
    }
    fimWord = fimWord.nextWord!;
  }
  FimWord fimWord = FimWord.empty();

  FimWord? findWord(int offset) {
    FimWord word = fimWord;
    while (word.hasNext) {
      if (word.containOffset(offset)) {
        return word;
      }
      word = word.nextWord!;
    }
    return null;
  }
}

class FimWord {
  FimWord({
    required this.start,
    required this.data,
    this.nextWord,
    this.beforeWord,
    this.afterNewLine = false,
  });
  final int start;
  int get end => start + data.length;
  String data;
  bool afterNewLine;
  FimWord? nextWord;
  FimWord? beforeWord;

  bool get hasNext => nextWord != null;
  bool get hasBefore => beforeWord != null;
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

  void changeLine() {
    afterNewLine = true;
  }

  bool containOffset(int offset) {
    return start <= offset && end >= offset;
  }

  factory FimWord.empty() {
    return FimWord(
      start: 0,
      data: "",
      afterNewLine: false,
    );
  }
}
