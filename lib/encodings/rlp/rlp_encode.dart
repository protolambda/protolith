import 'dart:convert';
import 'dart:typed_data';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/encodings/serializeables/uint8_list_serializeable.dart';
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

/// Encoder for the RLP (Recursive Length Prefix) encoding.
/// Used to encode arbitrarily nested arrays of data.
/// See: https://github.com/ethereum/wiki/wiki/RLP
class RlpEncoder extends Converter<dynamic, Uint8List> {

  const RlpEncoder();

  static Uint8List maybeEncodeLength(Uint8List input) {
    // Note; empty lists in RLP are length encoded,
    //  while lists of 1 "small" item are not!
    if (input.length == 1 && input.first < 0x80) {
      return input;
    } else {
      return concatUint8Lists(encodeLength(input.length, 0x80), input);
    }
  }

  static Uint8List encodeLength(len, offset) {
    if (len < 56) {
      return new Uint8List.fromList([len + offset]);
    } else {
      Uint8List encodedLen = encodeInt(len);
      return concatUint8Lists(new Uint8List.fromList([encodedLen.length + offset + 55]), encodedLen);
    }
  }

  /// Convert any input that is either:
  ///  - a [String]
  ///  - a [int]
  ///  - a [BigInt]
  ///  - a [Uint8Serializeable]
  ///  - a [List] with convertible elements
  @override
  Uint8List convert(dynamic input) {
    if (input is List && input is! Uint8List) {
      Uint8List output = new Uint8List.fromList(input.expand(convert).toList());
      return concatUint8Lists(encodeLength(output.length, 0xc0), output);
    } else {
      return maybeEncodeLength(
          input is Uint8List
          ? input
          : input is String
          ? new Uint8List.fromList(input.codeUnits)
          : input is int
          ? encodeInt(input)
          : input is BigInt
          ? encodeBigInt(input)
          : input is Uint8ListEncodeable
          ? input.toUint8List()
          : throw new RlpEncodingException("Failed to encode to RLP: ${input}"));
    }
  }

}
