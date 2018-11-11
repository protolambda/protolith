import 'dart:typed_data';

import 'package:chainviz_server/blockchain/hash.dart';
import 'package:chainviz_server/blockchain/pow/ethash/constants.dart';
import 'package:chainviz_server/blockchain/pow/ethash/fnv.dart';
import 'package:chainviz_server/crypto/data_util.dart';
import 'package:chainviz_server/crypto/sha3.dart';

class HashimotoResult {
  /// The mix-hash
  Hash256 digest;

  /// The hash used to check against the POW difficulty.
  Hash256 blockHash;

  HashimotoResult(this.digest, this.blockHash);
}

// Returns a byte list, byte count = HASH_BYTES
typedef Uint8List DatasetLookup(int i);

typedef Hash256 MixHashMaker(
    Hash512 seed, int full_size, DatasetLookup lookupFn);

/// Hashimoto main function.
/// Inputs:
/// - [headerHash] represents the SHA3-256 hash of the RLP representation
///   of a truncated block header (i.e. excluding the fields mixHash and nonce)
/// - [nonce] the 64 bit integer solution of the mining process.
/// - [full_size] the size of the DAG of the current hashimoto epoch
/// - [lookupFn] used to get a value from the DAG.
HashimotoResult hashimoto(
    Hash256 headerHash, int nonce, int full_size, DatasetLookup lookupFn) {
  Hash512 seedHash = computeSeedHash(headerHash, nonce);

  // Create the mix-hash.
  // This is a compositional function;
  // it can be changed to return an already-known mix-hash,
  // in case we are doing a pre-check
  //
  // (This is an anti DDOS measure to not create the mix-hash before
  //   checking some other requirements of Ethash)
  Hash256 mixHash = calculateMixHash(seedHash, full_size, lookupFn);

  Hash256 blockHash = computeBlockHash(seedHash, mixHash);

  return new HashimotoResult(mixHash, blockHash);
}

Hash256 computeBlockHash(Hash512 seedHash, Hash256 mixHash) {
  // Create the input sequence for the final hash
  Uint8List hashInputBytes = new Uint8List(HASH_BYTES + Hash256.BYTES);
  // Add the seed
  hashInputBytes.setRange(0, HASH_BYTES, seedHash.uint8list);
  // Append the compressed mix
  hashInputBytes.setRange(HASH_BYTES, hashInputBytes.length, mixHash.uint8list);
  // Final hash to combine digest with seed.
  return sha3_256(byteView(hashInputBytes));
}

Hash512 computeSeedHash(Hash256 headerHash, int nonce) {
  Uint8List inputBytes = new Uint8List(Hash256.BYTES + NONCE_BYTES);
  ByteData inputView = byteView(inputBytes);
  inputBytes.setRange(0, Hash256.BYTES, headerHash.uint8list);
  // Nonce is inserted in little-endian order
  inputView.setUint64(Hash256.BYTES, nonce, Endian.little);
  // combine header+nonce into a 64 byte seed
  return sha3_512(inputView);
}

/// The algorithm that computes the mix-hash from scratch
Hash256 calculateMixHash(Hash512 seed, int full_size, DatasetLookup lookupFn) {
  int rows = full_size ~/ HASH_BYTES;
  int seedHead = seed.data.getUint32(0, Endian.little);
  // start the mix with replicated s
  Uint8List mix = new Uint8List(MIX_BYTES);
  ByteData mixView = byteView(mix);
  for (int i = 0; i < mix.length; i += HASH_BYTES) {
    mix.setRange(i, i + HASH_BYTES, seed.uint8list);
  }
  // mix in random dataset nodes
  Uint8List temp = new Uint8List(mix.length);
  ByteData tempView = byteView(temp);
  for (int i = 0; i < ACCESSES; i++) {
    int p = fnv(i ^ seedHead,
        mixView.getUint32((i % MIX_WORDS) << 3, Endian.little) % rows);
    for (int j = 0; j < MIX_HASHES; j++) {
      // TODO: Geth source says 2*p + j, while wiki says p + j
      Uint8List lookupHash = lookupFn(p + j);
      int start = j * HASH_BYTES;
      temp.setRange(start, start + HASH_BYTES, lookupHash);
    }
    fnvHash(mixView, tempView);
  }
  // Compress mix
  for (int i = 0, j = 0; i < MIX_BYTES; j++) {
    mixView.setUint32(
        j,
        fnv(
            fnv(
                fnv(mixView.getUint32(i++, Endian.little),
                    mixView.getUint32(i++, Endian.little)),
                mixView.getUint32(i++, Endian.little)),
            mixView.getUint32(i++, Endian.little)),
        Endian.little);
  }
  // We are only interested in the first 1/4 of the mix (=32 bytes),
  //  which is the result of compression.
  return new Hash256(byteView(mix, length: Hash256.BYTES));
}
