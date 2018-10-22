import 'dart:async';

import 'package:chainviz_server/blockchain.dart';
import 'package:chainviz_server/blockchain/hash.dart';

abstract class Block {

  /// QUANTITY - the block number. null when its pending block.
  int number;

  ///QUANTITY - the unix timestamp for when the block was collated.
  int timestamp;

  Hash256 _hash;

  /// DATA, 32 Bytes - hash of the block. null when its pending block.
  Hash256 get hash => _hash ?? (_hash = computeHash());

  /// DATA, 32 Bytes - hash of the parent block.
  Hash256 parentHash;

  Hash256 computeHash();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Block &&
              runtimeType == other.runtimeType &&
              hash == other.hash;

  @override
  int get hashCode => hash.hashCode;

  Future<bool> validate(BlockChain chain) async {
    // Return false by default. Implementor has the say if it's really valid.
    return false;
  }

}
