
import 'dart:typed_data';

import 'package:chainviz_server/blockchain/hash.dart';

class UncleBlockData {

  ///DATA, 32 Bytes - SHA3 of the uncles data in the block.
  Uint8List sha3Uncles;

  ///Array - Array of uncle hashes.
  List<Hash256> uncles;

}
