import 'dart:async';

import 'package:chainviz_server/blockchain/address.dart';
import 'package:chainviz_server/blockchain/hash.dart';
import 'package:chainviz_server/blockchain/pow/ethash/epoch.dart';
import 'package:chainviz_server/blockchain/pow/ethash/hashimoto.dart';

import 'package:pointycastle/src/utils.dart';

class EthashBlockData {

  ///DATA, 8 Bytes - nonce from mining POW.
  int nonce;

  ///DATA, 20 Bytes - the address of the beneficiary to whom the mining rewards were given.
  EthereumAddress miner;

  ///QUANTITY - integer of the difficulty for this block.
  BigInt difficulty;

  ///QUANTITY - integer of the total difficulty of the chain until this block.
  BigInt totalDifficulty;

  Future<bool> verifyPOW(HashimotoEpoch epoch, Hash256 headerHash, Hash256 mixHash) async {
    HashimotoResult result = epoch.hashimotoLight(headerHash, nonce);
    if (result.digest != mixHash) return false;

    // decode hash into big-endian BigInt, and check if it is low enough.
    BigInt hashRes = decodeBigInt(result.blockHash.uint8list);
    return (hashRes <= (BigInt.from(1) << 256) ~/ difficulty);
  }
}
