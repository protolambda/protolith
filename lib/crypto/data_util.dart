import 'dart:typed_data';

Uint8List uint8View(TypedData data, {skip: 0, length: null})
  => new Uint8List.view(data.buffer,
      data.offsetInBytes + skip, length ?? data.lengthInBytes);

ByteData byteView(TypedData data, {skip: 0, length: null})
  => new ByteData.view(data.buffer,
      data.offsetInBytes + skip, length ?? data.lengthInBytes);

/// Check, element-wise, if the elements of [a] and [b] are equal.
bool equalUint8lists(Uint8List a, Uint8List b) {
  if (a.lengthInBytes != b.lengthInBytes) return false;
  for (int i = 0; i < a.lengthInBytes; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
