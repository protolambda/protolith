
import 'dart:async';

import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/db/blocks/block_db.dart';
import 'package:protolith/blockchain/exceptions/unknown_block.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

class BlockChain<M extends BlockMeta, B extends Block<M>> {

  Hash256 _headBlockHash;
  Hash256 get headBlockHash => _headBlockHash;

  Future<B> get headBlock => db.getBlockByHash(headBlockHash);

  // Public field, it should be easy to change the DB.
  BlockDB<M,B> db;

  Future<B> getBlock(Hash256 hash) {
    return db.getBlockByHash(hash);
  }

  Future addBlock(B block) async {
    // Require that the block meets the requirements in the context of
    // connecting it to the currently synced chain, and validate the block.
    // Validation throws if the block is invalid.
    await block.validate(this);
    // It's validated, now add it.
    return await addValidBlock(block);
  }

  /// Just force-adds the block, it must be valid.
  Future addValidBlock(B block) async {
    await db.putBlock(block);
    if (await forkChoice(await headBlock, block)) {
      _headBlockHash = block.hash;
    }
  }

  /// Returns true if [block] should be the new head of the chain.
  /// Override this to implement consensus systems.
  /// E.g. POW would choice the head based on total accumulated POW.
  Future<bool> forkChoice(B head, B block) async {
    /// Simple base implementation: just pick the highest block number.
    return block.number > head.number;
  }

  /// Returns the post-state for the block [blockHash].
  /// To be overridden by subclasses to provide their own extended metadata.
  Future<M> getBlockMeta(Hash256 hash) async {
    // Check if the block is known. If not, we cannot construct a post-state for the block.
    B b = await this.getBlock(hash);
    if (b == null) throw UnknownBlockException(hash, "Block hash is unknown. Cannot build state for it.");

    return BlockMeta()..blockNum = b.number;
  }

}
