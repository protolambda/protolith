import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

mixin OutputBlockData<M extends BlockMeta> on Block<M> {

  ///QUANTITY - integer the size of this block in bytes.
  int size;

}
