import 'package:fim/fim.dart';
import 'package:fim/src/model/fim_text.dart';
import 'package:fim/src/model/fim_value.dart';
import 'package:flutter/material.dart';

class FimController extends ValueNotifier<FimValue> {
  FimController({String text = ""})
      : super(
          FimValue(
            fimText: FimText(text: text),
          ),
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
    if (baseOffset == 0) {
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
