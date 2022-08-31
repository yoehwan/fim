
import 'package:flutter/material.dart';

class FimController extends TextEditingController {
  FimController({
    String? text,
  }) {
    value = TextEditingValue(
      text: text ?? "aa bb cc dd ee\nee ff aa cc ",
      selection: const TextSelection.collapsed(
        offset: 0,
      ),
      composing: const TextRange.collapsed(0),
    );
  }

  late TextPainter textPainter;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        package: "fim",
        fontFamily: "Hack",
        color: Colors.black,
        // fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}
