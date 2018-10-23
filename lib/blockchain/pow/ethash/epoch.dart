
import 'dart:typed_data';

import 'package:chainviz_server/blockchain/hash.dart';
import 'package:chainviz_server/blockchain/pow/ethash/cache.dart';
import 'package:chainviz_server/blockchain/pow/ethash/constants.dart';
import 'package:chainviz_server/blockchain/pow/ethash/hashimoto.dart';
import 'package:chainviz_server/blockchain/pow/ethash/size.dart';
import 'package:chainviz_server/crypto/data_util.dart';
import 'package:chainviz_server/crypto/sha3.dart';

class HashimotoEpoch {

  // block-number of the start of this epoch
  final int blockNum;

  final int epochNum;

  final int cacheSize;

  final int fullSize;

  // Seed-hash of this epoch
  final Hash512 seedHash;

  UnmodifiableByteDataView _cache;

  HashimotoEpoch(this.blockNum, this.seedHash)
      : this.epochNum = blockNum ~/ EPOCH_LENGTH,
        this.cacheSize = getCacheSize(blockNum ~/ EPOCH_LENGTH),
        this.fullSize = getFullSize(blockNum ~/ EPOCH_LENGTH);

  HashimotoEpoch mkNextEpoch() =>
      new HashimotoEpoch(blockNum + 1, sha3_512(seedHash.data));


  void loadCache() {
    // TODO prime number
    _cache = makeCache(cacheSize, seedHash);
  }


  @override
  String toString() => 'HashimotoEpoch{EpochNum: $epochNum}';

  UnmodifiableUint8ListView _calcDatasetItem(x) {
    if (_cache == null) throw StateError(
        "Cache is not initialized! Epoch: $epochNum");
    return new UnmodifiableUint8ListView(
        uint8View(_cache, skip: x * HASH_BYTES, length: HASH_BYTES));
  }

  HashimotoResult hashimotoLight(Hash256 headerBytes, int nonce) =>
      hashimoto(headerBytes, nonce, fullSize, _calcDatasetItem);

}