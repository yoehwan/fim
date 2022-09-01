import 'package:fim/fim.dart';
import 'package:fim/src/model/fim_text.dart';
import 'package:fim/src/model/fim_value.dart';
import 'package:flutter/material.dart';

const testText = "aa bb cc dd ee \naa bb dfdf   er ";

class FimController extends ValueNotifier<FimValue> {
  FimController({
    String? text,
  }) : super(
          FimValue(
            fimText: FimText(text ?? testText),
            offset: 0,
            mode: FimMode.insert,
          ),
        );
  FimText get fimText => value.fimText;
  String get text => value.fimText.text;
  int get offset => value.offset;
  set offset(int newOffset) {
    if (value.offset == newOffset) {
      return;
    }
    value = value.copyWith(offset: newOffset);
  }

  FimMode get mode => value.mode;
  set mode(FimMode newMode) {
    if (value.mode == newMode) {
      return;
    }
    value = value.copyWith(mode: newMode);
  }

  void insertChar(int offset, String char) {
    final newText = text.characters.toList();
    newText.insert(offset, char);
    value = value.copyWith(
      fimText: FimText(newText.join()),
      offset: offset + 1,
    );
  }

  void removeChar(int offset) {
    final newText = text.characters.toList();
    newText.removeAt(offset);
    value = value.copyWith(
      fimText: FimText(newText.join()),
      offset: offset - 1,
    );
  }

  TextSpan buildTextSpan() {
    return TextSpan(
      text: value.fimText.text,
      style: const TextStyle(
        package: "fim",
        fontFamily: "Hack",
        color: Colors.black,
      ),
    );
  }
}
