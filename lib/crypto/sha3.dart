
import 'dart:typed_data';

import 'package:pointycastle/digests/sha3.dart';

final SHA3Digest sha3digest_256 = new SHA3Digest(256);

Uint8List sha3_256(Uint8List input) {
  sha3digest_256.reset();
  return sha3digest_256.process(input);
}

final SHA3Digest sha3digest_512 = new SHA3Digest(512);

Uint8List sha3_512(Uint8List input) {
  sha3digest_512.reset();
  return sha3digest_512.process(input);
}
