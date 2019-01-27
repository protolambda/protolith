import 'dart:async';

import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/db/blocks/block_db.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

class InMemoryBlockDB<M extends BlockMeta, B extends Block<M>> extends BlockDB<M, B> {

  Map<Hash256, B> byHash = {};

  @override
  Future putBlock(B block) async {
    byHash[block.hash] = block;
  }

  @override
  Future<B> getBlockByHash(Hash256 hash) async => byHash[hash];

  @override
  Future<B> deleteBlock(Hash256 hash) async {
    B block = byHash.remove(hash);
    return block;
  }

}
