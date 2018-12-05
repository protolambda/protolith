import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

mixin GasStateBlockData<M extends BlockMeta> on Block<M> {

  ///QUANTITY - the maximum gas allowed in this block.
  int gasLimit;

  ///QUANTITY - the total used gas by all transactions in this block.
  int gasUsed;

}
