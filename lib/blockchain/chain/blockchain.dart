
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
    if (await block.validate(getBlockMeta(block.number))) {
      await db.putBlock(block);
    } else {
      throw InvalidBlockException<M, B>(block, "Block is invalid, cannot add it to the DB.");
    }
  }

  /// To be overridden by subclasses to provide their own extended metadata.
  BlockMeta getBlockMeta(int blockNum) => new BlockMeta()..blockNum = blockNum;

}
