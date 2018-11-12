/// The RLP (Recursive Length Prefix) encoding.
/// Used to encode arbitrarily nested arrays of data.
/// See: https://github.com/ethereum/wiki/wiki/RLP

import 'dart:convert';
import 'dart:typed_data';
import 'package:chainviz_server/encodings/serializeables/uint8_serializeable.dart';
import 'package:pointycastle/src/utils.dart';

const _rlpEncoder = const RlpEncoder();

/// Encode an input with the default RLP encoder.
final encodeRLP = _rlpEncoder.convert;


class RlpEncodingException implements Exception {
  final message;

  RlpEncodingException([this.message]);

  String toString() {
    if (message == null) return "RlpEncodingException";
    return "RlpEncodingException: $message";
  }
}

class RlpEncoder extends Converter<dynamic, Uint8List> {

  const RlpEncoder();

  static Uint8List maybeEncodeLength(Uint8List input) {
    if (input.length == 1 && input.first < 0x80) {
      return input;
    } else {
      return encodeLength(input.length, 0x80) + input;
    }
  }

  static Uint8List encodeLength(len, offset) {
    if (len < 56) {
      return new Uint8List.fromList([len + offset]);
    } else {
      Uint8List binary = encodeInt(len);
      return new Uint8List.fromList([binary.length + offset + 55]) + binary;
    }
  }

  static Uint8List encodeInt(int x) {
    int len = (x.bitLength >> 3) + 1;
    Uint8List res = new Uint8List(len);
    // big-endian
    for (int i = 0; i < len; i++) {
      res[len - 1 - i] = (x >> (i << 3)) & 0xFF;
    }
    return res;
  }

  /// Convert any input that is either:
  ///  - a [String]
  ///  - a [int]
  ///  - a [BigInt]
  ///  - a [Uint8Serializeable]
  ///  - a [List] with convertible elements
  @override
  Uint8List convert(dynamic input) {
    if (input is List) {
      Uint8List output = new Uint8List.fromList(input.expand(convert).toList());
      return encodeLength(output.length, 0xc0) + output;
    } else {
      return maybeEncodeLength(
            input is String
          ? new Uint8List.fromList(input.codeUnits)
          : input is int
          ? encodeInt(input)
          : input is BigInt
          ? encodeBigInt(input)
          : input is Uint8Serializeable
          ? input.toUint8List()
          : throw new RlpEncodingException("Failed to encode to RLP: ${input}"));
    }
  }

}
