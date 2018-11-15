import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:test/test.dart';
import 'package:protolith/encodings/rlp/rlp_encode.dart';
import 'package:protolith/encodings/rlp/rlp_decode.dart';

void main() {
  Map tests = jsonDecode(File('tests/fixtures/RLPTests/rlptest.json').readAsStringSync());

  group("RLP encode", () {
    tests.forEach((key, value) {
      dynamic input = value['in'];
      String output = value['out'];

      test(key, () {
        Uint8List encoded = encodeRLP(parseInput(input));
        var hexEncoded = hex.encode(encoded.toList());
        expect(hexEncoded, output);
      });
    });
  });

  group("RLP decode", () {
    tests.forEach((key, value) {
      String output = value['out'];

      test(key, () {
        dynamic decoded = decodeRLP(new Uint8List.fromList(hex.decode(output)));
        // RLP makes no difference in types;
        //  when decoding, you get byte-arrays instead of strings / variable length integers.
        // Trick: we encode it again, and see if it matches the original input.
        // Now if the encode tests work, we can deduce this decoding works as well
        //  (although not exactly back to typed input data)
        dynamic encoded = encodeRLP(decoded);
        var hexEncoded = hex.encode(encoded.toList());
        expect(hexEncoded, output);
      });
    });
  });
}

dynamic parseInput(dynamic value) {
  if (value is String && value.startsWith('#'))
    return BigInt.parse(value.substring(1));
  return value;
}
