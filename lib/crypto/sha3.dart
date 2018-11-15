
import 'dart:typed_data';

import 'package:protolith/blockchain/hash.dart';
import 'package:pointycastle/digests/sha3.dart';

final SHA3Digest sha3digest_256 = new SHA3Digest(256);

Hash256 sha3_256(ByteData input) {
  sha3digest_256.reset();
  return new Hash256.fromTypedData(sha3digest_256.process(
      new Uint8List.view(
          input.buffer, input.offsetInBytes, input.lengthInBytes
      )
  ));
}

final SHA3Digest sha3digest_512 = new SHA3Digest(512);

Hash512 sha3_512(ByteData input) {
  sha3digest_512.reset();
  return new Hash512.fromTypedData(sha3digest_512.process(
      new Uint8List.view(
          input.buffer, input.offsetInBytes, input.lengthInBytes
      )
  ));
}
