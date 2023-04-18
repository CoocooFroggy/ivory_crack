import 'dart:convert';

void main(List<String> arguments) {
  final pieces = [
    ['V7'],
    ['rm', 'nm'],
    ['JO', 'Jo', 'J0'],
    ['O8', '08', 'OB', '0B'],
    ['k4'],
    ['ON', '0N', 'oN'],
    ['y1'],
    ['eI', 'el'],
    ['3+'],
    ['Mm'],
    ['IA', 'lA'],
    ['=='],
  ];

  final choiceIndexes = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  // final pieces = [
  //   ['01', '02', '03'],
  //   ['AA', 'BB'],
  //   ['IA', 'lA'],
  //   ['=='],
  // ];
  //
  // final choiceIndexes = [
  //   0,
  //   0,
  //   0,
  //   0,
  // ];

  iterateFromIndex(pieces, 0, choiceIndexes);
}

void iterateFromIndex(
    List<List<String>> pieces, int index, List<int> choiceIndexes) {
  for (var choice in pieces[index]) {
    // If we are not on the last index
    if (index != choiceIndexes.length - 1) {
      // Do all iterations under our piece
      iterateFromIndex(pieces, index + 1, choiceIndexes);
    } else {
      // Only print if we're at the end of the chain
      final currentB64 = compile(pieces, choiceIndexes);
      print('---');
      print(currentB64);
      print(utf8.decode(base64Decode(currentB64), allowInvalid: true));
    }
    // If we have other choices, try them
    if (choiceIndexes[index] + 1 < pieces[index].length) {
      choiceIndexes[index] += 1;
    }
  }
  choiceIndexes[index] = 0;
}

String compile(List<List<String>> pieces, List<int> choiceIndexes) {
  final buffer = StringBuffer();
  // Loop through all pieces
  for (int i = 0; i < pieces.length; i++) {
    // Choose that index
    buffer.write(pieces[i][choiceIndexes[i]]);
  }
  return buffer.toString();
}
