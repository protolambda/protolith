
import 'package:protolith/blockchain/pow/ethash/constants.dart';
import 'package:protolith/crypto/prime.dart';

int getCacheSize(int epochNum) {
  int size = CACHE_BYTES_INIT + CACHE_BYTES_GROWTH * epochNum;
  size -= HASH_BYTES;
  while (!isPrime(size ~/ HASH_BYTES)) {
    size -= 2 * HASH_BYTES;
  }
  return size;
}

int getFullSize(int epochNum) {
  int size = DATASET_BYTES_INIT + DATASET_BYTES_GROWTH * epochNum;
  size -= MIX_BYTES;
  while (!isPrime(size ~/ MIX_BYTES)) {
    size -= 2 * MIX_BYTES;
  }
  return size;
}
