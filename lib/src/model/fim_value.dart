import 'package:equatable/equatable.dart';
import 'package:fim/src/enum/mode.dart';
import 'package:fim/src/model/fim_text.dart';
import 'package:flutter/material.dart';

class FimValue extends Equatable {
  const FimValue({
    required this.fimText,
    this.caretOffset = 0,
    this.mode = FimMode.insert,
    this.selection = const TextSelection.collapsed(offset: 0),
  });
  final int caretOffset;
  final FimText fimText;
  final FimMode mode;
  final TextSelection selection;

  FimValue copyWith({
    FimText? fimText,
    FimMode? mode,
    TextSelection? selection,
    int? caretOffset,
  }) {
    return FimValue(
      fimText: fimText ?? this.fimText,
      mode: mode ?? this.mode,
      selection: selection ?? this.selection,
      caretOffset: caretOffset ?? this.caretOffset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "fimText": fimText,
      "mode": mode,
      "selection": selection,
      "caretOffset": caretOffset,
    };
  }

  @override
  List<Object?> get props => [fimText, mode, selection, caretOffset];
}
