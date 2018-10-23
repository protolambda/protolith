import 'dart:typed_data';

import 'package:chainviz_server/blockchain/hash.dart';
import 'package:chainviz_server/blockchain/pow/ethash/constants.dart';
import 'package:chainviz_server/crypto/data_util.dart';
import 'package:chainviz_server/crypto/sha3.dart';

UnmodifiableByteDataView makeCache(int cacheSize, Hash512 seed) {
  int n = cacheSize ~/ HASH_BYTES;

  Uint8List output = new Uint8List(cacheSize);
  ByteData outputView = byteView(output);

  // Sequentially produce the initial dataset
  Hash512 hashRes = sha3_512(seed.data);
  output.setRange(0, HASH_BYTES, hashRes.uint8list);
  for (int i = 1, j = HASH_BYTES; i < n; i++, j += HASH_BYTES) {
    // Hash previous output
    hashRes = sha3_512(hashRes.data);
    output.setRange(j, j + HASH_BYTES, hashRes.uint8list);
  }

  Uint8List temp = new Uint8List(HASH_BYTES);
  ByteData tempView = byteView(temp);
  // Use a low-round version of randmemohash
  for (int round = 0; round < CACHE_ROUNDS; round++) {
    for (int i = 0; i < n; i++) {
      int srcOffset = (i - 1 + n) % n;
      int dstOffset = i * HASH_BYTES;
      int xorOffset =
          (outputView.getUint32(dstOffset, Endian.little) % n) * HASH_BYTES;
      for (int xi = 0; xi < HASH_BYTES; xi++) {
        temp[xi] = output[srcOffset + xi] ^ output[xorOffset + xi];
      }
      Hash512 hash = sha3_512(tempView);
      output.setRange(dstOffset, dstOffset + HASH_BYTES, hash.uint8list);
    }
  }

  // Cache may not be modified later, return an immutable view of data.
  return new UnmodifiableByteDataView(outputView);
}
