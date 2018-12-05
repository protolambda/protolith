import 'dart:typed_data';

Uint8List uint8View(TypedData data, {skip: 0, length: null})
  => new Uint8List.view(data.buffer,
      data.offsetInBytes + skip, length ?? (data.lengthInBytes - skip));

ByteData byteView(TypedData data, {skip: 0, length: null})
  => new ByteData.view(data.buffer,
      data.offsetInBytes + skip, length ?? (data.lengthInBytes - skip));

/// Check, element-wise, if the elements of [a] and [b] are equal.
bool equalUint8lists(Uint8List a, Uint8List b) {
  if (a.lengthInBytes != b.lengthInBytes) return false;
  for (int i = 0; i < a.lengthInBytes; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

Uint8List concatUint8Lists(Uint8List a, Uint8List b) =>
  new Uint8List(a.length + b.length)
    ..setRange(0, a.length, a)
    ..setRange(a.length, a.length + b.length, b);

/// Converts the integer to a big-endian representation, padded to 32 bytes.
Uint8List as32Bytes(int v) => uint8View(new Uint64List.fromList([0, 0, 0, v]));

final _byteMask = new BigInt.from(0xff);

/// Encodes the [BigInt] [v], big-endian,
///  into a byte array of length [outBytesLen].
///
/// See PointyCastle (Crypto library) for decoding and non-padded encoding.
Uint8List encodeBigIntPadded(BigInt v, int outBytesLen) {
  /// When serializing, always serialize to 40 bytes,
  /// regardless if the address "fits" in 39 or lower.
  /// It's not worth the inconsistency.
  var result = new Uint8List(outBytesLen);
  BigInt work = v;
  // big-endian
  for (int i = 0; i < outBytesLen; i++) {
    result[outBytesLen - i - 1] = (work & _byteMask).toInt();
    work = work >> 8;
  }
  return result;
}
