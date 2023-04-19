import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/paddings/pkcs7.dart';

void main(List<String> arguments) {
  final pieces = [
    ['V7'],
    ['rm'],
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

  iterateFromIndex(pieces, 0, choiceIndexes);
}

void iterateFromIndex(
    List<List<String>> pieces, int index, List<int> choiceIndexes) {
  for (var _ in pieces[index]) {
    // If we are not on the last index
    if (index != choiceIndexes.length - 1) {
      // Do all iterations under our piece
      iterateFromIndex(pieces, index + 1, choiceIndexes);
    } else {
      // Only act if we're at the end of the chain
      final currentB64 = compile(pieces, choiceIndexes);
      act(currentB64);
    }
    // If we have other choices, try them
    if (choiceIndexes[index] + 1 < pieces[index].length) {
      choiceIndexes[index] += 1;
    }
  }
  choiceIndexes[index] = 0;
}

void act(String currentB64) {
  print('---');
  print(currentB64);
  print(hex.encode(base64Decode(currentB64)));
  print(utf8.decode(base64Decode(currentB64), allowMalformed: true));

  print(decryptBase64String(currentB64, '4444dsc', 'WHITEPINE'));
  print(decryptBase64String(currentB64, '4444dsc', ''));
}

String decryptBase64String(String encryptedBase64, String password, String saltStr) {
  // Decode the Base64-encoded string to bytes
  Uint8List encryptedBytes = base64.decode(encryptedBase64);

  // Derive a key and IV from the password using PBKDF2
  var salt = Uint8List.fromList(saltStr.codeUnits);
  if (saltStr == '') {
    salt = Uint8List(0);
  }
  final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 32));
  final params = Pbkdf2Parameters(salt, 1000, 16);
  pbkdf2.init(params);
  final key = pbkdf2.process(Uint8List.fromList(password.codeUnits));

  // Use AES/CBC/PKCS7 to decrypt the bytes
  final cbc = CBCBlockCipher(AESFastEngine());
  final paramsCBC = ParametersWithIV(KeyParameter(key), Uint8List(16));
  cbc.init(false, paramsCBC);
  final paddedDecryptedBytes = cbc.process(encryptedBytes);

  // Remove padding and convert to a string
  final padCount = paddedDecryptedBytes[paddedDecryptedBytes.length - 1];
  try {
    final decryptedBytes = paddedDecryptedBytes.sublist(0, paddedDecryptedBytes.length - padCount);
    final decoded = utf8.decode(decryptedBytes);
    return decoded;
  } catch (e) {
    print(e);
    return '';
  }
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
