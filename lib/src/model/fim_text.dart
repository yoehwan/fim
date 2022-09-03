library fim_text;

import 'dart:collection';

import 'package:equatable/equatable.dart';

part 'fim_word.dart';
part 'fim_line.dart';

class FimText with EquatableMixin {
  FimText({this.text = ""}) {
    int offset = 0;
    int lineOffset = 0;
    final lineList = text.split(RegExp(r"\n"));
    for (int index = 0; index < lineList.length; index++) {
      final lineNumber = index + 1;
      final line = lineList[index];
      final tmpLine = FimLine(
        line: lineNumber,
        start: lineOffset + index,
        data: line,
      );
      fimLine.add(tmpLine);
      lineOffset += line.length;
      final wordList = line.split(RegExp(r"\s"));
      for (final word in wordList) {
        if (word.trim().isNotEmpty) {
          final tmpWord = FimWord(
            line: lineNumber,
            start: offset,
            data: word,
          );
          fimWord.add(tmpWord);
          offset = tmpWord.end + 2;
        } else {
          offset++;
        }
      }
    }
  }
  final LinkedList<FimLine> fimLine = LinkedList();
  final LinkedList<FimWord> fimWord = LinkedList();
  final String text;

  FimWord? findNextWord(int offset) {
    FimWord? word = fimWord.first;
    if (word.start > offset) {
      return word;
    }
    word = word.next;
    while (word != null) {
      if (word.start > offset) {
        return word;
      }
      word = word.next;
    }
    return null;
  }

  FimWord? findBeforeWord(int offset) {
    FimWord? word = fimWord.last;
    if (word.end < offset) {
      return word;
    }
    word = word.previous;
    while (word != null) {
      if (word.end < offset) {
        return word;
      }
      word = word.previous;
    }
    return null;
  }

  FimWord? findWord(int offset) {
    FimWord? word = fimWord.first;
    if (word.containOffset(offset)) {
      return word;
    }
    word = word.next;
    while (word != null) {
      if (word.containOffset(offset)) {
        return word;
      }
      word = word.next;
    }
    return null;
  }

  FimLine? findLine(int offset) {
    FimLine? line = fimLine.first;
    if (line.containOffset(offset)) {
      return line;
    }
    line = line.next;
    while (line != null) {
      if (line.containOffset(offset)) {
        return line;
      }
      line = line.next;
    }
    return null;
  }

  @override
  List<Object?> get props => [text];
}
