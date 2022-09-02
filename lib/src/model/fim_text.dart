library fim_text;

import 'package:equatable/equatable.dart';

part 'fim_word.dart';

class FimText with EquatableMixin {
  FimText({this.text = ""}) {
    fimWord = FimWord.empty();
    int offset = 0;
    FimWord beforeWord = fimWord;
    final wordList = text.split(RegExp(r"\s|\n"));
    for (final word in wordList) {
      if (word.trim().isNotEmpty) {
        final tmpWord = FimWord(
          start: offset,
          data: word,
          beforeWord: beforeWord,
        );
        fimWord.add(tmpWord);
        beforeWord = tmpWord;
        offset = tmpWord.end + 2;
      } else {
        offset++;
      }
    }
  }
  final String text;
  late FimWord fimWord;

  FimWord? findNextWord(int offset) {
    FimWord word = fimWord;
    if (word.start > offset) {
      return word;
    }
    while (word.hasNext) {
      word = word.nextWord!;
      if (word.start > offset) {
        return word;
      }
    }
    return null;
  }

  FimWord? findBeforeWord(int offset) {
    FimWord word = fimWord.last();
    if (word.end < offset) {
      return word;
    }
    while (word.hasBefore) {
      word = word.beforeWord!;
      if (word.end < offset) {
        return word;
      }
    }
    return null;
  }

  FimWord? findWord(int offset) {
    FimWord word = fimWord;
    if (word.containOffset(offset)) {
      return word;
    }
    while (word.hasNext) {
      word = word.nextWord!;
      if (word.containOffset(offset)) {
        return word;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [text];
}
