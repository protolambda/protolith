
import 'dart:async';

import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/db/blocks/db.dart';
import 'package:protolith/blockchain/exceptions/invalid_block.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

class BlockChain<M extends BlockMeta, B extends Block<M>> {

  int blockHeight = 0;

  Future<B> get lastBlock async {
    Hash256 hash = (await db.getBlocksByNumber(blockHeight))?.first;
    if (hash != null) return await db.getBlockByHash(hash);
    return null;
  }

  // Public field, it should be easy to change the DB.
  BlockDB<M,B> db;

  Future<B> getBlock(Hash256 hash) {
    return db.getBlockByHash(hash);
  }

  Future addBlock(B block) async {
    // Require that the block meets the requirements in the context of
    // connecting it to the currently synced chain, and validate the block itself.
    if (await validateNewBlock(block) && await block.validate(await getBlockMeta(block.number))) {
      await db.putBlock(block);
    } else {
      throw InvalidBlockException<M, B>(block, "Block is invalid, cannot add it to the DB.");
    }
  }

  /// Future throws if block is invalid.
  Future validateNewBlock(B block) async {
    if (block.number > blockHeight) throw Exception("Node is at ${blockHeight}, cannot validate block ${block.number}");
    B prev = await getBlock(block.hash);
    if (prev == null) throw Exception("Block parent hash is unknown.");
    // TODO: timestamp validation is ignored, timestamps are manipulated for demo purposes.
  }

  /// To be overridden by subclasses to provide their own extended metadata.
  Future<M> getBlockMeta(int blockNum) async => new BlockMeta()..blockNum = blockNum;

}
