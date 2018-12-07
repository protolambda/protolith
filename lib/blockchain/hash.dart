
import 'dart:typed_data';

import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/encodings/serializeables/uint8_list_serializeable.dart';

/**
 * 256 bit hash, immutable.
 */
class Hash256 implements Uint8ListEncodeable {

  /// Length of this type of hash.
  static const int BYTES = 32;

  UnmodifiableByteDataView _data;

  UnmodifiableByteDataView get data => _data;

  Uint8List get uint8list => _data.buffer.asUint8List(
      _data.offsetInBytes, _data.lengthInBytes
  );

  Hash256.fromTypedData(TypedData input) : this(
      new ByteData.view(input.buffer, input.offsetInBytes, input.lengthInBytes));

  Hash256(ByteData data) {
    if (data.lengthInBytes != 32)
      throw new ArgumentError("Invalid hash being initialized! Data must be 256 bits (32 bytes)!");
    this._data = new UnmodifiableByteDataView(data);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Hash256
              && runtimeType == other.runtimeType
              && equalUint8lists(uint8list, other.uint8list));

  // It's a hash, the first 64 bits should be good enough as an object hashcode.
  @override
  int get hashCode => _data.getUint64(0);

  @override
  Uint8List toUint8List() => uint8View(_data);

}

/**
 * 512 bit hash, immutable.
 */
class Hash512 implements Uint8ListEncodeable {

  /// Length of this type of hash.
  static const int BYTES = 64;

  UnmodifiableByteDataView _data;

  UnmodifiableByteDataView get data => _data;

  Uint8List get uint8list => _data.buffer.asUint8List(
      _data.offsetInBytes, _data.lengthInBytes
  );

  Hash512.fromTypedData(TypedData input) : this(
      new ByteData.view(input.buffer, input.offsetInBytes, input.lengthInBytes));

  Hash512(ByteData data) {
    if (data.lengthInBytes != 64)
      throw new ArgumentError("Invalid hash being initialized! Data must be 512 bits (64 bytes)!");
    this._data = new UnmodifiableByteDataView(data);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Hash256
              && runtimeType == other.runtimeType
              && equalUint8lists(uint8list, other.uint8list));

  // It's a hash, the first 64 bits should be good enough as an object hashcode.
  @override
  int get hashCode => _data.getUint64(0);

  @override
  Uint8List toUint8List() => uint8View(_data);

}
