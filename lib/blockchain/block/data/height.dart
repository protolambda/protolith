import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/meta/blocks/metas/height.dart';
import 'package:protolith/blockchain/exceptions/invalid_block.dart';

mixin HeightBlockData<M extends HeightBlockMeta> on Block<M> {

  /// QUANTITY - the block number. null when its pending block.
  int number;

  Future validate(M pre) async {

    // To override in any sub-class.
    // Then call super.validate(pre) to keep behaviour of other mixins.
    if (number != pre.blockNum + 1)
      throw InvalidBlockException<M, Block<M>>(this,
          "Known pre state is at ${pre.blockNum}, block with number ${number} cannot be connected.");

    // TODO: timestamp validation is ignored, timestamps are manipulated for demo purposes.
  }

}
