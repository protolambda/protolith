
import 'package:protolith/blockchain/block/standard_block.dart';
import 'package:protolith/blockchain/chain/block_chain.dart';
import 'package:protolith/blockchain/meta/blocks/standard_meta.dart';

class StandardBlockChain<M extends StandardBlockMeta, B extends StandardBlock<M>> extends BlockChain<M, B> {

  @override
  Future<M> getBlockMeta(int blockNum) async {
    // TODO: get meta with Ethash data handle
    return new StandardBlockMeta()..blockNum = blockNum;
  }

  @override
  Future validateNewBlock(B block) {
    // validate basics: block-number and parent-hash
    super.validateNewBlock(block);
    // TODO: validate more than just the basic requirements
  }


}
