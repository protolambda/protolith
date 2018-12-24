import 'dart:async';

import 'package:protolith/blockchain/chain/block_chain.dart';
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
  Future validate(BlockChain<M, Block<M>> chain) async {
    // Get the post-state of the previous block.
    // This will be the pre-state for this block.
    // (throws if no pre-state is available)
    BlockMeta meta = await chain.getBlockMeta(parentHash);

    await validateWithState(meta);
  }

  /// Future, throws if invalid
  Future validateWithState(M meta) async {
    if (number != meta.blockNum + 1)
      throw InvalidBlockException<M, Block<M>>(this,
          "Known pre state is at ${meta.blockNum}, block with number ${number} cannot be connected.");

    // TODO: timestamp validation is ignored, timestamps are manipulated for demo purposes.
  }
}
