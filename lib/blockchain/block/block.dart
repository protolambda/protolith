import 'dart:async';

import 'package:protolith/blockchain/exceptions/invalid_block.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/mixins/lazy_hashed.dart';

abstract class Block<M extends BlockMeta> with LazyHashed<Hash256> {
  /// QUANTITY - the block number. null when its pending block.
  int number;

  ///QUANTITY - the unix timestamp for when the block was collated.
  int timestamp;

  /// DATA, 32 Bytes - hash of the block. null when its pending block.
  Hash256 get hash => super.hash;

  /// DATA, 32 Bytes - hash of the parent block.
  Hash256 parentHash;

  /// Compute the block-hash: this is the hash
  ///  of the full RLP encoded header.
  Hash256 computeHash(M meta);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Block && runtimeType == other.runtimeType && hash == other.hash;

  @override
  int get hashCode => hash.hashCode;

  /// Future, throws if invalid
  Future validate(M pre) async {
    if (number != pre.blockNum + 1)
      throw InvalidBlockException<M, Block<M>>(this,
          "Known pre state is at ${pre.blockNum}, block with number ${number} cannot be connected.");

    // TODO: timestamp validation is ignored, timestamps are manipulated for demo purposes.
  }

  /// Applies the implications of this block to [delta],
  ///  a meta data DB view of the post-state of the parent block of this block,
  ///  storing every change, to be finalized once the block processing is done
  ///  (i.e. hash is known).
  Future applyToDelta(M delta) async {
    if (delta.blockNum + 1 != number)
      throw Exception(
          "Cannot apply block changes at height ${number} to meta at ${delta.blockNum}");
    if (delta.blockHash != parentHash)
      throw Exception(
          "Cannot apply block changes in block, building on parent ${parentHash}, to meta at block ${delta.blockHash}");

  }
}
