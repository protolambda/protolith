import 'dart:async';

import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/pow/ethash/epoch.dart';
import 'package:protolith/blockchain/pow/ethash/hashimoto.dart';

import 'package:pointycastle/src/utils.dart';

class EthashBlockData {
  ///DATA, 8 Bytes - nonce from mining POW.
  int nonce;

  ///DATA, 20 Bytes - the address of the beneficiary to whom the mining rewards were given.
  EthereumAddress beneficiary;

  ///QUANTITY - integer of the difficulty for this block.
  BigInt difficulty;

  ///QUANTITY - integer of the total difficulty of the chain until this block.
  BigInt totalDifficulty;

  Future<bool> verifyPOW(
      HashimotoEpoch epoch, Hash256 headerHash, Hash256 mixHash) async {
    Hash512 seedHash = computeSeedHash(headerHash, nonce);
    // Check using the supplied untrusted mix-hash first,
    // to ensure that at least some work was done before generating the mixHash ourselves.
    Hash256 blockHash = computeBlockHash(seedHash, mixHash);
    if (!checkDifficulty(blockHash)) return false;

    // Now create the mixHash ourselves, and see if it matches the untrusted mixHash.
    // If it does, then everything is ok, as we already checked the difficulty against this hash.
    // If it doesn't match, then we are being deceived.
    // The mix-hash is added to the block-data for this pre-check purpose, it should match!
    Hash256 trustedMixHash = epoch.calcMixHashLight(seedHash);
    return trustedMixHash == mixHash;
  }

  bool checkDifficulty(Hash256 hash) {
    // decode hash into big-endian BigInt, and check if it is low enough.
    BigInt hashRes = decodeBigInt(hash.uint8list);
    return (hashRes <= (BigInt.from(1) << 256) ~/ difficulty);
  }
}
