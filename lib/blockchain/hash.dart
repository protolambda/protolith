
import 'dart:typed_data';

/**
 * 256 bit hash, immutable.
 */
class Hash256 {

  UnmodifiableByteDataView _data;

  UnmodifiableByteDataView get data => _data;

  Uint8List get uint8list => _data.buffer.asUint8List(
      _data.offsetInBytes, _data.lengthInBytes
  );

  Hash256.fromUint8List(Uint8List input) : this(
      new ByteData.view(input.buffer, input.offsetInBytes, input.lengthInBytes));

  Hash256(ByteData data) {
    if (data.lengthInBytes != 32)
      throw new ArgumentError("Invalid blockhash being initialized! Data must be 256 bits (32 bytes)!");
    this._data = new UnmodifiableByteDataView(data);
  }

}

/**
 * 512 bit hash, immutable.
 */
class Hash512 {

  UnmodifiableByteDataView _data;

  UnmodifiableByteDataView get data => _data;

  Uint8List get uint8list => _data.buffer.asUint8List(
      _data.offsetInBytes, _data.lengthInBytes
  );

  Hash512.fromUint8List(Uint8List input) : this(
      new ByteData.view(input.buffer, input.offsetInBytes, input.lengthInBytes));

  Hash512(ByteData data) {
    if (data.lengthInBytes != 64)
      throw new ArgumentError("Invalid blockhash being initialized! Data must be 512 bits (64 bytes)!");
    this._data = new UnmodifiableByteDataView(data);
  }

}
