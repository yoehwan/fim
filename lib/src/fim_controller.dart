import 'package:fim/fim.dart';
import 'package:fim/src/model/fim_syntax.dart';
import 'package:fim/src/model/fim_text.dart';
import 'package:fim/src/model/fim_value.dart';
import 'package:flutter/material.dart';

class FimController extends ValueNotifier<FimValue> {
  FimController({String text = ""})
      : super(FimValue(fimText: FimText(text: text)));

  final FimSyntax? syntax = FimSyntax(
    "dart",
    {
      "brightRed": 0xFFfb4934,
      "brightOrange": 0xFFfe8019,
      "class": "brightOrange",
      "extends": "brightOrange",
      "for": "brightRed",
    },
  );

  FimText get fimText => value.fimText;
  set fimText(FimText newValue) {
    if (value.fimText == newValue) {
      return;
    }
    value = value.copyWith(fimText: newValue);
  }

  String get text => fimText.text;

  FimMode get mode => value.mode;
  set mode(FimMode newValue) {
    if (value.mode == newValue) {
      return;
    }

    value = value.copyWith(
      mode: newValue,
      selection: TextSelection.collapsed(offset: selection.baseOffset),
    );
  }

  TextSelection get selection => value.selection;
  set selection(TextSelection newValue) {
    if (value.selection == newValue) {
      return;
    }
    value = value.copyWith(selection: newValue);
  }

  void insertChar(int offset, String char) {
    final newText = text.characters.toList();
    newText.insert(offset, char);
    value = value.copyWith(
      fimText: FimText(text: newText.join()),
      selection: TextSelection.collapsed(offset: offset + 1),
    );
  }

  void removeSelection(TextSelection removeSelection) {
    final baseOffset = removeSelection.baseOffset;
    if (selection.extentOffset == 0) {
      return;
    }
    value = value.copyWith(
      fimText: FimText(
        text:
            removeSelection.textBefore(text) + removeSelection.textAfter(text),
      ),
      selection: TextSelection.collapsed(offset: baseOffset),
    );
  }

  TextSpan buildTextSpan() {
    final List<TextSpan> list = [];
    final lines = text.split("\n");
    final linesLen = lines.length;
    const defaultStyle = TextStyle(
      package: "fim",
      fontFamily: "Hack",
      color: Colors.black,
    );
    for (int index = 0; index < linesLen; index++) {
      final line = lines[index];
      final words = line.split(" ");
      final List<TextSpan> wordSpanList = [];
      for (final word in words) {
        TextStyle tmpStyle = defaultStyle;
        if (syntax != null) {
          final color = syntax!.color(word);
          if (color != null) {
            tmpStyle = defaultStyle.apply(color: color);
          }
        }
        wordSpanList.add(TextSpan(text: word, style: tmpStyle));
        wordSpanList.add(TextSpan(text: ' ', style: tmpStyle));
      }
      wordSpanList.removeLast();
      list.addAll(wordSpanList);
      list.add(const TextSpan(text: "\n", style: defaultStyle));
    }
    list.removeLast();
    return TextSpan(children: list, style: defaultStyle);
  }
}
