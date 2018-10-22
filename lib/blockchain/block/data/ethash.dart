
import 'dart:async';
import 'dart:typed_data';

import 'package:chainviz_server/blockchain/address.dart';

class EthashBlockData {

  ///DATA, 8 Bytes - nonce from mining POW.
  int nonce;

  ///DATA, 20 Bytes - the address of the beneficiary to whom the mining rewards were given.
  EthereumAddress miner;

  ///QUANTITY - integer of the difficulty for this block.
  BigInt difficulty;

  ///QUANTITY - integer of the total difficulty of the chain until this block.
  BigInt totalDifficulty;

  Future<bool> verifyPOW(EthashCache cache, Uint8List mixHash) {

  }
}
