import 'package:fim/src/enum/mode.dart';
import 'package:fim/src/model/fim_text.dart';

class FimValue {
  FimValue({
    required this.offset,
    required this.fimText,
    required this.mode,
  });
  final int offset;
  final FimText fimText;
  final FimMode mode;
  FimValue copyWith({
    int? offset,
    FimText? fimText,
    FimMode? mode,
  }) {
    return FimValue(
      offset: offset ?? this.offset,
      fimText: fimText ?? this.fimText,
      mode: mode ?? this.mode,
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "offset":offset,
      "fimText":fimText,
      "mode":mode,
    };
  }
}
