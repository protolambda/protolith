import 'dart:typed_data';

import 'package:convert/convert.dart';

export 'package:pointycastle/src/utils.dart';

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

Uint8List concatUint8Lists(Uint8List a, Uint8List b) {
  Uint8List res = new Uint8List(a.length + b.length)
    ..setRange(0, a.length, a)..setRange(a.length, a.length + b.length, b);
  String out = hex.encode(res);
  return res;
}

/// Converts the integer to a big-endian representation, padded to 32 bytes.
Uint8List intAs32Bytes(int v) => uint8View(new Uint64List.fromList([0, 0, 0, v]));

/// Encode an integer as a byte-array, but limit the result to [maxLen] bytes.
/// Throws an exception if it is more.
Uint8List encodeIntMaxLen(int v, maxLen) {
  Uint8List res = encodeInt(v);
  if (res.lengthInBytes > maxLen)
    throw Exception("Encoding may not be bigger than $maxLen bytes.");
  return res;
}

Uint8List encodeInt(int x) {
  // note the integer 0 has a bitlength of 0,
  //  and is encoded as an empty uint8 list.
  int bits = x.bitLength;
  int len = (bits >> 3);
  // if not divisible by 8, round up.
  if (bits & 7 != 0) len++;
  Uint8List res = new Uint8List(len);
  // big-endian
  for (int i = 0; i < len; i++) {
    res[len - 1 - i] = (x >> (i << 3)) & 0xFF;
  }
  return res;
}

/// Convert a byte array to a int (not a big int, max. cap 8 bytes)
int intFromBytes(Uint8List arr) {
  // Take last 8 bytes
  int x = 0;
  int i = arr.lengthInBytes - 8;
  // there may be less than 8 bytes.
  if (i < 0) i = 0;
  for (; i < arr.lengthInBytes; i++) {
    x <<= 8;
    x |= arr[i];
  }
  return x;
}

final _byteMask = new BigInt.from(0xff);

/// Encodes the [BigInt] [v], big-endian,
///  into a byte array of length [outBytesLen].
///
/// See PointyCastle (Crypto library) for decoding and non-padded encoding
///  (exported by this file).
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

/// pass-trhough function to easily verify lengths of arrays.
Uint8List limitSize(Uint8List v, {int minLen: 0, int maxLen: 32}) {
  if (v.lengthInBytes < minLen) throw Exception("Uint8list is too short! (${v.lengthInBytes} instead of min. $minLen)");
  if (v.lengthInBytes > maxLen) throw Exception("Uint8list is too long! (${v.lengthInBytes} instead of max. $maxLen)");
  return v;
}

bool listElementwiseComparison<T>(List<T> as, List<T> bs) {
  if (as.length != bs.length) return false;
  for (int i = 0; i < as.length; i++) {
    if (as[i] != bs[i]) return false;
  }
  return true;
}

/// returns true if [a] and [b] are equal.
typedef bool BinaryComparator<T>(T a, T b);

bool listElementwiseComparisonFn<T>(List<T> as, List<T> bs, BinaryComparator<T> cFn) {
  if (as.length != bs.length) return false;
  for (int i = 0; i < as.length; i++) {
    if (!cFn(as[i], bs[i])) return false;
  }
  return true;
}

repeatFn<X>(X fn(X x)) {
  innerRepeat(x, n) => n == 0 ? x : innerRepeat(fn(x), n - 1);
  return innerRepeat;
}

