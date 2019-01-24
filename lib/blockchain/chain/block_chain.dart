
import 'dart:async';

import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/db/blocks/block_db.dart';
import 'package:protolith/blockchain/db/meta_data/delta_db.dart';
import 'package:protolith/blockchain/db/meta_data/memory_db.dart';
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';
import 'package:protolith/blockchain/exceptions/unknown_block.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

class BlockChain<M extends BlockMeta, B extends Block<M>> {

  /// Changing this hash will change the head of the chain.
  Hash256 headBlockHash;

  Future<B> get headBlock => blockDB.getBlockByHash(headBlockHash);

  // Public field, it should be easy to change the DB.
  BlockDB<M,B> blockDB;

  // Meta data db, where meta is actually stored.
  // (BlockMeta is the most common view to work on this meta data).
  MetaDataDB metaDB;

  Future<B> getBlock(Hash256 hash) {
    return blockDB.getBlockByHash(hash);
  }

  /// Add the [block] to this chain. It may not be part of the canonical chain.
  Future addBlock(B block) async {

    // Create a temporary storage for changes
    DeltaDB deltaDB = new DeltaDB(new InMemoryMetaDataDB(), this.metaDB);
    // Create a handle for this DB, as a state for processing
    M meta = await getBlockMeta(block.parentHash, db: deltaDB);
    // First, prepare the meta, set-up the context to validate the block.
    await preProcessBlock(block, meta);
    // Require that the block meets the requirements in the context of
    // connecting it to the currently synced chain, and validate the block.
    // Validation throws if the block is invalid.
    await validateBlock(block, meta);
    // Process the block, i.e. hash will become known, and chain state is updated.
    await processBlock(block, meta);
    // It's validated, now add it.
    await addValidBlock(block);

    // Now that the block is processed, we know the hash.
    // Now merge back the temporary changes into the main DB,
    //  using the hash of the block as part of the key.
    await this.metaDB.putDataset(deltaDB.change);

    // Now, post-process the state after handling the block
    await postProcessBlock(block, meta);
  }

  /// Force-adds the block, it must be valid.
  Future addValidBlock(B block) async {
    await blockDB.putBlock(block);
  }

  /// Prepare the [meta] to validate and process the [block]
  Future preProcessBlock(B block, M meta) async {
    // Nothing to pre-process by default
  }

  /// Validate the [block]
  Future validateBlock(B block, M meta) async {
    // most of the validation focuses on the block, approach it from there.
    await block.validate(meta);
    // This function can be overridden to change or add validation behaviour.
  }

  /// Note: The supplied [block] is assumed to be validated.
  /// The block is processed by applying its changes to a temporary DB,
  ///  and then finalizing this temporary DB by adding it to the state.
  Future processBlock(B block, M meta) async {
    // Process the block
    block.applyToDelta(meta);
  }

  /// Update the [meta] to handle the effect of processing [block].
  /// The head of the chain is updated here.
  Future postProcessBlock(B block, M meta) async {
    // Check if the head needs to be updated
    B head = await this.headBlock;
    /// Simple base implementation: just pick the highest block number.
    if(block.number > head.number) {
      headBlockHash = head.hash;
    }
  }

  /// Returns a meta data view of the post-state for the block [blockHash].
  /// To be overridden by subclasses to provide their own extended view of meta data.
  /// Note: different behaviour for specific block heights/ranges can be implemented this way.
  /// Optionally one can supply a custom DB for meta data. E.g. for tracking/batching changes.
  Future<M> getBlockMeta(Hash256 hash, {MetaDataDB db}) async {
    // Check if the block is known. If not, we cannot construct a post-state for the block.
    B b = await this.getBlock(hash);
    if (b == null) throw UnknownBlockException(hash, "Block hash is unknown. Cannot build state for it.");

    // Create the view for the block.
    BlockMeta meta = new BlockMeta(b.hash, b.number, db ?? metaDB);

    return meta;
  }

}
