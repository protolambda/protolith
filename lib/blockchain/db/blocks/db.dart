
import 'dart:async';

import 'package:chainviz_server/blockchain/block/block.dart';
import 'package:chainviz_server/blockchain/hash.dart';
import 'package:chainviz_server/blockchain/meta/blocks/meta.dart';

abstract class BlockDB<M extends BlockMeta, B extends Block<M>> {

  Future putBlock(B block);

  Future<B> getBlockByHash(Hash256 hash);
  Future<Set<Hash256>> getBlocksByNumber(int number);

  Future<B> deleteBlock(Hash256 block);

}
