import 'dart:math' as math;
import 'package:fim/fim.dart';
import 'package:fim/src/intent/direction/direction_action.dart';
import 'package:fim/src/intent/direction/direction_intent.dart';
import 'package:fim/src/intent/mode/mode_action.dart';
import 'package:fim/src/intent/mode/mode_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Fim extends StatefulWidget {
  const Fim({
    super.key,
    required this.controller,
    required this.lineNumber,
  });
  final FimController controller;
  final bool lineNumber;
  @override
  State<Fim> createState() => _FimState();
}

class _FimState extends State<Fim> {
  final ValueNotifier<FimMode> modeNotifier = ValueNotifier(FimMode.command);
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  bool isArrow(LogicalKeyboardKey key) {
    final list = [0x00100000301, 0x00100000302, 0x00100000303, 0x00100000304];
    return list.contains(key.keyId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ColoredBox(
        color: Colors.black.withOpacity(0.1),
        child: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.keyA): InsertModeIntent(),
            SingleActivator(LogicalKeyboardKey.escape): CommandModeIntent(),
            SingleActivator(LogicalKeyboardKey.arrowLeft):
                DirectionIntent(TraversalDirection.left),
            SingleActivator(LogicalKeyboardKey.arrowRight):
                DirectionIntent(TraversalDirection.right),
            SingleActivator(LogicalKeyboardKey.arrowDown):
                DirectionIntent(TraversalDirection.down),
            SingleActivator(LogicalKeyboardKey.arrowUp):
                DirectionIntent(TraversalDirection.up),
          },
          child: Actions(
            actions: {
              CommandModeIntent: ModeAction(modeNotifier),
              InsertModeIntent: ModeAction(modeNotifier),
              DirectionIntent: DirectionAction(widget.controller),
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
                final logicalKey = event.logicalKey;
                if (isArrow(logicalKey) ||
                    logicalKey == LogicalKeyboardKey.controlLeft) {
                  return KeyEventResult.ignored;
                }
                String keyLabel = logicalKey.keyLabel;
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  keyLabel = "\n";
                }
                final text = widget.controller.text;
                final newText = text.characters.toList()
                  ..insert(widget.controller.selection.baseOffset, keyLabel);
                widget.controller.value = widget.controller.value.copyWith(
                  text: newText.join(),
                  selection: widget.controller.selection.copyWith(
                    baseOffset: widget.controller.selection.baseOffset + 1,
                  ),
                );
                return KeyEventResult.handled;
              },
              child: ValueListenableBuilder<FimMode>(
                valueListenable: modeNotifier,
                builder: (context, mode, _) {
                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: widget.controller,
                    builder: (context, value, _) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _FimRenderObjectWidget(
                              text: widget.controller.buildTextSpan(
                                context: context,
                                withComposing: true,
                              ),
                              lineNumber: widget.lineNumber,
                              caretOffset: value.selection.baseOffset,
                              mode: mode,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _FimRenderObjectWidget extends LeafRenderObjectWidget {
  const _FimRenderObjectWidget({
    Key? key,
    required this.text,
    required this.lineNumber,
    required this.caretOffset,
    required this.mode,
  }) : super(key: key);

  final InlineSpan? text;
  final bool lineNumber;
  final int caretOffset;
  final FimMode mode;

  @override
  RenderFim createRenderObject(BuildContext context) {
    return RenderFim(
      text: text,
      lineNumber: lineNumber,
      caretOffset: caretOffset,
      mode: mode,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderFim renderObject) {
    renderObject
      ..mode = mode
      ..caretOffset = caretOffset
      ..text = text
      ..lineNumber = lineNumber;
  }
}

class RenderFim extends RenderBox {
  RenderFim({
    InlineSpan? text,
    required bool lineNumber,
    required int caretOffset,
    required FimMode mode,
  })  : _mode = mode,
        _caretOffset = caretOffset,
        _lineNumber = lineNumber,
        _textPainter = TextPainter(
          text: text,
          textDirection: TextDirection.ltr,
        );

  late FimMode _mode;
  FimMode get mode => _mode;
  set mode(FimMode value) {
    if (_mode == value) {
      return;
    }
    _mode = value;
    markNeedsPaint();
  }

  Rect get caretRect => Rect.fromLTWH(
      0, 0, mode.isInsert ? 2 : 8, _textPainter.preferredLineHeight);
  late int _caretOffset;
  int get caretOffset => _caretOffset;
  set caretOffset(int value) {
    if (_caretOffset == value) {
      return;
    }
    _caretOffset = value;
    markNeedsPaint();
  }

  double get _lineNumberWidth {
    if (lineNumber) {
      return 30.0;
    }
    return 0;
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

  InlineSpan? get text => _textPainter.text;
  set text(InlineSpan? value) {
    if (text == value) {
      return;
    }
    _textPainter.text = value;
    markNeedsLayout();
  }

  final TextPainter _textPainter;

  void _layoutTextPainter() {
    _textPainter.layout();
  }

  @override
  void performLayout() {
    _layoutTextPainter();
    size = Size(
      _textPainter.width + _lineNumberWidth + caretRect.width,
      _textPainter.height,
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

  void _paintCaret(PaintingContext context, Offset offset) {
    final editorOffset = offset.translate(_lineNumberWidth, 0);
    final localOffset = _textPainter.getOffsetForCaret(
      TextPosition(offset: _caretOffset),
      caretRect,
    );
    context.canvas.drawRect(
      Rect.fromLTWH(
        localOffset.dx + editorOffset.dx,
        localOffset.dy + editorOffset.dy,
        caretRect.width,
        caretRect.height,
      ),
      Paint()..color = Colors.red.withOpacity(0.6),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _paintLineNumber(context, offset);
    _paintText(context, offset);
    _paintCaret(context, offset);
  }
}
