import 'dart:async';

import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

abstract class Block<M extends BlockMeta> {

  /// QUANTITY - the block number. null when its pending block.
  int number;

  ///QUANTITY - the unix timestamp for when the block was collated.
  int timestamp;

  Hash256 _hash;

  /// DATA, 32 Bytes - hash of the block. null when its pending block.
  Hash256 get hash => _hash;

  /// DATA, 32 Bytes - hash of the parent block.
  Hash256 parentHash;

  /// Compute the block-hash: this is the hash
  ///  of the full RLP encoded header.
  Hash256 computeHash(M meta);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Block &&
              runtimeType == other.runtimeType &&
              hash == other.hash;

  @override
  int get hashCode => hash.hashCode;

  Future<bool> validate(M meta) async {
    // Return false by default. Implementor has the say if it's really valid.
    return false;
  }

}
