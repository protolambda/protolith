/// The RLP (Recursive Length Prefix) encoding.
/// Used to encode arbitrarily nested arrays of data.
/// See: https://github.com/ethereum/wiki/wiki/RLP

import 'dart:convert';
import 'dart:typed_data';
import 'package:protolith/crypto/data_util.dart';

const _rlpDecoder = const RlpDecoder();

/// Decode an input with the default RLP decoder.
final decodeRLP = _rlpDecoder.convert;


class RlpDecodingException implements Exception {
  final message;

  RlpDecodingException([this.message]);

  String toString() {
    if (message == null) return "RlpDecodingException";
    return "RlpDecodingException: $message";
  }
}

class _RLPWindow {
  int offset, length;
  bool hasNestedData;
  _RLPWindow(this.offset, this.length, this.hasNestedData);
}

/// Decoder for the RLP (Recursive Length Prefix) encoding.
/// Used to encode arbitrarily nested arrays of data.
/// See: https://github.com/ethereum/wiki/wiki/RLP
class RlpDecoder extends Converter<Uint8List, dynamic> {

  const RlpDecoder();

  static int decodeInt(Uint8List x) {
    int res = 0;
    // add all bytes, creating a big-endian integer.s
    for (int b in x) {
      res <<= 8;
      res |= b;
    }
    return res;
  }

  /// Convert any a uint8list to its "decoded" form
  ///  (i.e. structured but raw elements):
  /// - non-list elements are decoded into [Uint8List]s
  /// - except for single byte values, these are decoded into [int]s
  /// - lists are decoded into [List]s of converted elements.
  /// So you may want to go over the resulting list
  ///  and decode the individual elements to their deserialized datatype.
  @override
  dynamic convert(Uint8List input) {
    _RLPWindow outWindow = _decodeWindow(input);
    if (!outWindow.hasNestedData) {
      return uint8View(input, skip: outWindow.offset, length: outWindow.length);
    } else {
      int remainingDataLen = outWindow.length;
      int offset = outWindow.offset;
      List<dynamic> out = [];
      while (remainingDataLen > 0) {
        _RLPWindow nestedWindow = _decodeWindow(uint8View(input, skip: offset, length: remainingDataLen));
        // Convert the first item in the window, and add it to the list
        out.add(convert(uint8View(input, skip: offset, length: remainingDataLen)));
        // Change the remaining window: we skip the item we just added, and reduce the length to reflect this.
        remainingDataLen -= nestedWindow.offset + nestedWindow.length;
        offset += nestedWindow.offset + nestedWindow.length;
      }
      return out;
    }
  }

  _RLPWindow _decodeWindow(Uint8List input) {
    if (input.length == 0) {
      return _RLPWindow(0, 0, false);
    } else {
      int prefix = input[0];
      if (prefix <= 0x7f) {
        return _RLPWindow(0, 1, false);
      } else if (prefix <= 0xb7) {
        int itemLen = prefix - 0x80;
        if (input.length < itemLen)
          throw new RlpDecodingException("Encoded data is not valid RLP!");
        return _RLPWindow(1, itemLen, false);
      } else if (prefix <= 0xbf) {
        int lenOfItemLen = prefix - 0xb7;

        if (input.length < lenOfItemLen)
          throw new RlpDecodingException("Encoded data is not valid RLP!");

        int itemLen = decodeInt(uint8View(input, skip: 1, length: lenOfItemLen));

        if(input.length < lenOfItemLen + itemLen)
          throw new RlpDecodingException("Encoded data is not valid RLP!");

        return _RLPWindow(1 + lenOfItemLen, itemLen, false);
      } else if (prefix <= 0xf7) {
        int listLen = prefix - 0xc0;
        if (input.length < listLen)
          throw new RlpDecodingException("Encoded data is not valid RLP!");

        return _RLPWindow(1, listLen, true);
      } else {
        int lenOfListLen = prefix - 0xf7;
        if (input.length < lenOfListLen)
          throw new RlpDecodingException("Encoded data is not valid RLP!");

        int listLen = decodeInt(uint8View(input, skip: 1, length: lenOfListLen));

        if (input.length < lenOfListLen + listLen)
          throw new RlpDecodingException("Encoded data is not valid RLP!");

        return _RLPWindow(1 + lenOfListLen, listLen, true);
      }
    }
  }

}
