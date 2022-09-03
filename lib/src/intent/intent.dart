library intent;

import 'dart:math' as math;
import 'package:fim/src/enum/mode.dart';
import 'package:fim/src/enum/word_postion.dart';
import 'package:fim/src/fim_controller.dart';
import 'package:fim/src/model/fim_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'mode/mode_intent.dart';
part 'mode/mode_action.dart';

part 'navigator/arrow/navigator_arrow_action.dart';
part 'navigator/arrow/navigator_arrow_intent.dart';

part 'navigator/word/navigator_word_action.dart';
part 'navigator/word/navigator_word_intent.dart';

part 'line/new_line_action.dart';
part 'line/new_line_intent.dart';

abstract class FimIntent extends Intent {
}
