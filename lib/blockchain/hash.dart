
import 'dart:typed_data';

/**
 * 256 bit hash, immutable.
 */
class Hash256 {

  UnmodifiableByteDataView _data;

  UnmodifiableByteDataView get data => _data;

  Hash256(ByteData data) {
    if (data.lengthInBytes != 32)
      throw new UnsupportedError("Invalid blockhash being initialized! Data must be 256 bits (32 bytes)!");
    this._data = new UnmodifiableByteDataView(data);
  }

}
