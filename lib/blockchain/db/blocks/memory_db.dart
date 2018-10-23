import 'dart:async';

import 'package:chainviz_server/blockchain/block/block.dart';
import 'package:chainviz_server/blockchain/db/blocks/db.dart';
import 'package:chainviz_server/blockchain/hash.dart';
import 'package:chainviz_server/blockchain/meta/blocks/meta.dart';

class InMemoryBlockDB<M extends BlockMeta, B extends Block<M>> extends BlockDB<M, B> {

  Map<Hash256, B> byHash = {};
  Map<int, Set<Hash256>> byNumber = {};

  @override
  Future putBlock(B block) async {
    byNumber.putIfAbsent(block.number, () => new Set()).add(block.hash);
    byHash[block.hash] = block;
  }

  @override
  Future<B> getBlockByHash(Hash256 hash) async => byHash[hash];

  @override
  Future<Set<Hash256>> getBlocksByNumber(int number) async => byNumber[number];

  @override
  Future<B> deleteBlock(Hash256 hash) async {
    B block = byHash.remove(hash);
    if (block != null) byNumber[block.number]?.remove(block);
    return block;
  }

}
