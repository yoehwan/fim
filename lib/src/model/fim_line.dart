part of fim_text;

class FimLine extends LinkedListEntry<FimLine> {
  FimLine({
    required this.line,
    required this.start,
    required this.data,
  });
  final int line;
  final int start;
  final String data;
  int get end => start + data.length;
  bool containOffset(int offset) {
    return start <= offset && offset <= end;
  }

  Map<String, dynamic> toMap() {
    return {
      "line": line,
      "start": start,
      "end": end,
      "data": data,
    };
  }
}
