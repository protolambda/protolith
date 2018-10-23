import 'dart:typed_data';

import 'package:chainviz_server/blockchain/hash.dart';
import 'package:chainviz_server/crypto/data_util.dart';
import 'package:chainviz_server/crypto/sha3.dart';

class HashimotoResult {
  UnmodifiableByteDataView digest;
  Hash256 blockHash;

  HashimotoResult(this.digest, this.blockHash);
}

const int WORD_BYTES = 4; // bytes in word
const int DATASET_BYTES_INIT = 1 << 30; // bytes in dataset at genesis
const int DATASET_BYTES_GROWTH = 1 << 23; // dataset growth per epoch
const int CACHE_BYTES_INIT = 1 << 24; // bytes in cache at genesis
const int CACHE_BYTES_GROWTH = 1 << 17; // cache growth per epoch
const int CACHE_MULTIPLIER = 1024; // Size of the DAG relative to the cache
const int EPOCH_LENGTH = 30000; // blocks per epoch
const int MIX_BYTES = 128; // width of mix
const int MIX_WORDS = MIX_BYTES ~/
    WORD_BYTES; // number of 32 bit words in the mix
const int HASH_BYTES = 64; // hash length in bytes
const int HASH_WORDS = 16; // number of 32 bit words in a hash
const int DATASET_PARENTS = 256; // number of parents of each dataset element
const int CACHE_ROUNDS = 3; // number of rounds in cache production
const int ACCESSES = 64; // number of accesses in hashimoto loop

int MIX_HASHES = MIX_BYTES ~/ HASH_BYTES;

// Returns a byte list, byte count = HASH_BYTES
typedef Uint8List DatasetLookup(int i);

const int FNV_PRIME = 0x01000193;

int fnv(int v1, int v2) => ((v1 * FNV_PRIME) ^ v2) & 0xffffffff;

// fnvHash mixes in data into mix using the ethash fnv method.
void fnvHash(ByteData mix, ByteData data) {
  for (int i = 0; i < MIX_BYTES; i += WORD_BYTES) {
    mix.setUint32(
        0, mix.getUint32(i) * 0x01000193 ^ data.getUint32(i), Endian.little);
  }
}

HashimotoResult hashimoto(Uint8List headerBytes, int nonce, int full_size,
    DatasetLookup lookupFn) {
  int rows = full_size ~/ HASH_BYTES;
  Uint8List inputBytes = new Uint8List(headerBytes.length + 8);
  ByteData inputView = byteView(inputBytes);
  inputBytes.setRange(0, headerBytes.length, headerBytes);
  // Nonce is inserted in little-endian order
  inputView.setUint64(headerBytes.lengthInBytes, nonce, Endian.little);
  // combine header+nonce into a 64 byte seed
  Hash512 seed = sha3_512(inputView);
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
    mixView.setUint32(j,
        fnv(
            fnv(
                fnv(
                    mixView.getUint32(i++, Endian.little),
                    mixView.getUint32(i++, Endian.little)
                ),
                mixView.getUint32(i++, Endian.little)
            ),
            mixView.getUint32(i++, Endian.little)
        ), Endian.little
    );
  }
  // We are only interested in the first 1/4 of the mix, that is the result of compression
  ByteData digest = byteView(mix, length: mix.length ~/ 4);
  // Create the input sequence for the final hash
  Uint8List hashInputBytes = new Uint8List(HASH_BYTES + digest.lengthInBytes);
  // Add the seed
  hashInputBytes.setRange(0, HASH_BYTES, seed.uint8list);
  // Append the compressed mix
  hashInputBytes.setRange(HASH_BYTES, hashInputBytes.length, mix);
  // Final hash to combine digest with seed.
  Hash256 result = sha3_256(byteView(hashInputBytes));

  return new HashimotoResult(new UnmodifiableByteDataView(digest), result);
}

class HashimotoEpoch {

  // block-number of the start of this epoch
  final int blockNum;

  int get epochNum => blockNum ~/ EPOCH_LENGTH;

  // Seed-hash of this epoch
  final Hash512 seedHash;

  UnmodifiableByteDataView _cache;

  HashimotoEpoch(this.blockNum, this.seedHash);

  HashimotoEpoch mkNextEpoch() =>
      new HashimotoEpoch(blockNum + 1, sha3_512(seedHash.data));


  void loadCache() {
    // TODO prime number
    int cacheSize = epochNum;
    _cache = _makeCache(cacheSize, seedHash);
  }

  static UnmodifiableByteDataView _makeCache(int cacheSize, Hash512 seed) {
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
        int xorOffset = (outputView.getUint32(dstOffset, Endian.little) % n)
            * HASH_BYTES;
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

  @override
  String toString() => 'HashimotoEpoch{EpochNum: $epochNum}';

  UnmodifiableUint8ListView _calcDatasetItem(x) {
    if (_cache == null) throw StateError(
        "Cache is not initialized! Epoch: $epochNum");
    return new UnmodifiableUint8ListView(
        uint8View(_cache, skip: x * HASH_BYTES, length: HASH_BYTES));
  }

  HashimotoResult hashimotoLight(Uint8List headerBytes,
      int nonce, int full_size) =>
      hashimoto(headerBytes, nonce, full_size, _calcDatasetItem);

}
