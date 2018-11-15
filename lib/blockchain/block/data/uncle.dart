
import 'dart:typed_data';

import 'package:protolith/blockchain/hash.dart';

class UncleBlockData {

  ///DATA, 32 Bytes - SHA3 of the uncles data in the block.
  Hash256 ommersHash;

  ///Array - Array of uncle hashes.
  List<Hash256> uncles;

}
