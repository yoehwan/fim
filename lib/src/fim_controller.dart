import 'dart:ui';

import 'package:flutter/material.dart';

class FimController extends TextEditingController {
  FimController({
    String? text,
  }) {
    value = TextEditingValue(
      text: text ?? "",
      selection: const TextSelection.collapsed(
        offset: 0,
      ),
      composing: const TextRange.collapsed(0),
    );
  }

  final FocusNode focusNode = FocusNode();

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(
      text: text,
      style: const TextStyle(
          color: Colors.black, fontFeatures: [FontFeature.tabularFigures()]),
    );
  }
}
