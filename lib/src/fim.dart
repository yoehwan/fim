import 'dart:math' as math;
import 'package:fim/fim.dart';
import 'package:fim/src/intent/intent.dart';
import 'package:fim/src/model/fim_value.dart';
import 'package:fim/src/shortcut/fim_shortcut.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Fim extends StatefulWidget {
  final FimController controller;
  final bool lineNumber;
  const Fim({
    super.key,
    required this.controller,
    required this.lineNumber,
  });
  @override
  State<Fim> createState() => _FimState();
}

class _FimState extends State<Fim> {
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  FimController get controller => widget.controller;
  FimMode get mode => controller.mode;

  late ShortcutManager _manager;

  void _loadManager() {
    _manager = ShortcutManager(
      shortcuts: {
        ...defaultShortcuts(),
        ...insertShortcuts(mode),
        ...commandShortcuts(mode),
        ...visualShortcuts(mode),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadManager();
    controller.addListener(_listener);
  }

  void _listener() {
    _loadManager();
  }

  bool isArrow(LogicalKeyboardKey key) {
    final list = [0x00100000301, 0x00100000302, 0x00100000303, 0x00100000304];
    return list.contains(key.keyId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ColoredBox(
          color: Colors.black.withOpacity(0.1),
          child: ValueListenableBuilder<FimValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final mode = value.mode;
              return Shortcuts.manager(
                manager: _manager,
                child: Actions(
                  actions: {
                    ModeIntent: ModeAction(controller),
                    NavigatorWordIntent: NavigatorWordAction(controller),
                    NavigatorArrowIntent: NavigatorArrowAction(controller),
                    NewLineIntent: NewLineAction(controller),
                    InsertCharIntent: InsertCharAction(),
                  },
                  child: Focus(
                    autofocus: true,
                    includeSemantics: false,
                    debugLabel: 'FimEditor-$hashCode',
                    focusNode: focusNode,
                    onKey: (node, event) {
                      if (event is RawKeyUpEvent) {
                        return KeyEventResult.handled;
                      }
                      if (mode.isInsert) {
                        final logicalKey = event.logicalKey;
                        String? char = event.character;
                        if (isArrow(logicalKey) ||
                            logicalKey == LogicalKeyboardKey.controlLeft) {
                          return KeyEventResult.ignored;
                        }
                        if (logicalKey == LogicalKeyboardKey.escape) {
                          return KeyEventResult.ignored;
                        }
                        String keyLabel = logicalKey.keyLabel;
                        if (logicalKey == LogicalKeyboardKey.enter) {
                          keyLabel = "\n";
                        }
                        final isBS = logicalKey == LogicalKeyboardKey.backspace;
                        final caretOffset = controller.caretOffset;
                        if (isBS) {
                          controller.removeSelection(
                            TextSelection(
                              baseOffset: caretOffset-1,
                              extentOffset: caretOffset,
                            ),
                          );
                        } else {
                          if (char != null) {
                            if (event.logicalKey == LogicalKeyboardKey.enter) {
                              char = "\n";
                            }
                            controller.insertChar(
                              caretOffset,
                              char,
                            );
                          }
                        }
                      }
                      return KeyEventResult.ignored;
                    },
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _FimRenderObjectWidget(
                            text: controller.buildTextSpan(),
                            lineNumber: widget.lineNumber,
                            mode: mode,
                            selection: value.selection,
                            caretOffset: value.caretOffset,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _FimRenderObjectWidget extends LeafRenderObjectWidget {
  const _FimRenderObjectWidget({
    Key? key,
    required this.text,
    required this.lineNumber,
    required this.mode,
    required this.selection,
    required this.caretOffset,
  }) : super(key: key);
  final InlineSpan? text;
  final bool lineNumber;
  final FimMode mode;
  final TextSelection selection;
  final int caretOffset;
  @override
  RenderFim createRenderObject(BuildContext context) {
    return RenderFim(
      text: text,
      lineNumber: lineNumber,
      mode: mode,
      selection: selection,
      caretOffset: caretOffset,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderFim renderObject) {
    renderObject
      ..caretOffset = caretOffset
      ..selection = selection
      ..mode = mode
      ..text = text
      ..lineNumber = lineNumber;
  }
}

class RenderFim extends RenderBox {
  RenderFim({
    InlineSpan? text,
    required bool lineNumber,
    required FimMode mode,
    required TextSelection selection,
    required int caretOffset,
  })  : _caretOffset = caretOffset,
        _selection = selection,
        _mode = mode,
        _lineNumber = lineNumber,
        _textPainter = TextPainter(
          text: text,
          textDirection: TextDirection.ltr,
        );

  late int _caretOffset;
  int get caretOffset => _caretOffset;
  set caretOffset(int value) {
    if (_caretOffset == value) {
      return;
    }
    _caretOffset = value;
    markNeedsPaint();
  }

  late TextSelection _selection;
  TextSelection get selection => _selection;
  set selection(TextSelection value) {
    if (_selection == value) {
      return;
    }
    _selection = value;
    markNeedsPaint();
  }

  Rect get caretRect {
    return Rect.fromLTWH(
      0,
      0,
      mode.isInsert ? 2 : 8,
      _textPainter.preferredLineHeight,
    );
  }

  late bool _lineNumber;
  bool get lineNumber => _lineNumber;

  set lineNumber(bool value) {
    if (_lineNumber == value) {
      return;
    }
    _lineNumber = value;
    markNeedsPaint();
  }

  late FimMode _mode;
  FimMode get mode => _mode;
  set mode(FimMode value) {
    if (_mode == value) {
      return;
    }
    _mode = value;
    markNeedsPaint();
  }

  final TextPainter _textPainter;
  InlineSpan? get text => _textPainter.text;
  set text(InlineSpan? value) {
    if (text == value) {
      return;
    }
    _textPainter.text = value;
    markNeedsLayout();
  }

  double get _lineNumberWidth {
    if (lineNumber) {
      return 30.0;
    }
    return 0;
  }

  void _layoutTextPainter() {
    _textPainter.layout();
  }

  void _paintSelection(PaintingContext context, Offset offset) {
    final List<TextBox> boxList = _textPainter.getBoxesForSelection(selection);
    final editorOffset = offset.translate(_lineNumberWidth, 0);

    final caretSize = caretRect.size.bottomRight(Offset.zero);
    for (final box in boxList) {
      final rect = box.toRect().shift(editorOffset);
      context.canvas.drawRect(
        rect,
        Paint()..color = Colors.red.withOpacity(0.6),
      );
    }
    final Offset extentOffset = _textPainter.getOffsetForCaret(
      TextPosition(offset: selection.extentOffset),
      caretRect,
    );
    context.canvas.drawRect(
      Rect.fromPoints(
        editorOffset + extentOffset,
        editorOffset + extentOffset + caretSize,
      ),
      Paint()..color = Colors.red.withOpacity(0.6),
    );
  }

  void _paintCaret(PaintingContext context, Offset offset) {
    final editorOffset = offset.translate(_lineNumberWidth, 0);
    final caretPosition = _textPainter.getOffsetForCaret(
          TextPosition(offset: caretOffset),
          caretRect,
        ) +
        editorOffset;
    final paint = Paint()..color = Colors.red.withOpacity(0.6);
    context.canvas.drawRect(
      Rect.fromLTWH(
        caretPosition.dx,
        caretPosition.dy,
        caretRect.width,
        caretRect.height,
      ),
      paint,
    );
  }

  void _paintLineNumber(PaintingContext context, Offset offset) {
    if (!_lineNumber) {
      return;
    }
    final lineLength = math.max(1, _textPainter.computeLineMetrics().length);
    final tp = TextPainter(
      text: TextSpan(
        style: _textPainter.text?.style,
        text: List.generate(lineLength, (index) {
          return "${index + 1}";
        }).join("\n"),
      ),
      textAlign: TextAlign.end,
      textDirection: TextDirection.ltr,
    );
    tp
      ..layout(maxWidth: _lineNumberWidth - 8, minWidth: _lineNumberWidth - 8)
      ..paint(context.canvas, offset);
  }

  void _paintText(PaintingContext context, Offset offset) {
    final editorOffset = offset.translate(_lineNumberWidth, 0);
    _textPainter.paint(context.canvas, editorOffset);
  }

  @override
  void performLayout() {
    _layoutTextPainter();
    size = Size(
      _textPainter.width + _lineNumberWidth + caretRect.width,
      _textPainter.height,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _paintLineNumber(context, offset);
    _paintText(context, offset);
    _paintCaret(context, offset);
  }
}
