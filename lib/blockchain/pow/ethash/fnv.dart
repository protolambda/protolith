import 'dart:typed_data';
import 'package:protolith/blockchain/pow/ethash/constants.dart';

const int FNV_PRIME = 0x01000193;

int fnv(int v1, int v2) => ((v1 * FNV_PRIME) ^ v2) & 0xffffffff;

// fnvHash mixes in data into mix using the ethash fnv method.
void fnvHash(ByteData mix, ByteData data) {
  for (int i = 0; i < MIX_BYTES; i += WORD_BYTES) {
    mix.setUint32(
        0, mix.getUint32(i) * 0x01000193 ^ data.getUint32(i), Endian.little);
  }
}
