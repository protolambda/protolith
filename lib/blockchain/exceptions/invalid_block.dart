import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

class InvalidBlockException<M extends BlockMeta, B extends Block<M>> implements Exception {

  final B block;
  final String msg;

  InvalidBlockException(this.block, this.msg);

  @override
  String toString() {
    return 'InvalidBlockException: $msg\nblock: $block';
  }


}