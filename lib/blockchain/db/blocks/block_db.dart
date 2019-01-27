
import 'dart:async';

import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

abstract class BlockDB<M extends BlockMeta, B extends Block<M>> {

  Future putBlock(B block);

  Future<B> getBlockByHash(Hash256 hash);

  Future<B> deleteBlock(Hash256 block);

}
