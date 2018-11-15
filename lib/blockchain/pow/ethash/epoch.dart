import 'dart:typed_data';

import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/pow/ethash/cache.dart';
import 'package:protolith/blockchain/pow/ethash/constants.dart';
import 'package:protolith/blockchain/pow/ethash/hashimoto.dart';
import 'package:protolith/blockchain/pow/ethash/size.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/crypto/sha3.dart';

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
    _cache = makeCache(cacheSize, seedHash);
  }

  @override
  String toString() => 'HashimotoEpoch{EpochNum: $epochNum}';

  UnmodifiableUint8ListView _calcDatasetItem(x) {
    if (_cache == null)
      throw StateError("Cache is not initialized! Epoch: $epochNum");
    return new UnmodifiableUint8ListView(
        uint8View(_cache, skip: x * HASH_BYTES, length: HASH_BYTES));
  }

  /// For the common hashimoto usage
  HashimotoResult hashimotoLight(Hash256 headerHash, int nonce) =>
      hashimoto(headerHash, nonce, fullSize, _calcDatasetItem);

  /// For advanced use; when the seedHash is already computed,
  ///  one can continue to calculate mixHash.
  /// Used to continue a POW verification after mix-hash pre-checking.
  Hash256 calcMixHashLight(Hash512 seedHash) =>
      calculateMixHash(seedHash, fullSize, _calcDatasetItem);
}
