import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

mixin TimeBlockData<M extends BlockMeta> on Block<M> {

  ///QUANTITY - the unix timestamp for when the block was collated.
  int timestamp;

  Future validate(M pre) async {
    super.validate(pre);
    // TODO: timestamp validation
  }

}
