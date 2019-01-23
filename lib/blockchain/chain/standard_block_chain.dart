
import 'package:protolith/blockchain/block/standard_block.dart';
import 'package:protolith/blockchain/chain/block_chain.dart';
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';
import 'package:protolith/blockchain/exceptions/unknown_block.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/standard_meta.dart';

class StandardBlockChain<M extends StandardBlockMeta, B extends StandardBlock<M>> extends BlockChain<M, B> {

  /// Returns the post-state for the block [blockHash].
  Future<M> getBlockMeta(Hash256 hash, {MetaDataDB db}) async {
    // Check if the block is known. If not, we cannot construct a post-state for the block.
    B b = await this.getBlock(hash);
    if (b == null) throw UnknownBlockException(hash, "Block hash is unknown. Cannot build state for it.");

    // Create the view for the block.
    StandardBlockMeta meta = new StandardBlockMeta(b.hash, b.number, db ?? metaDB);

    return meta;
  }

  /// Returns true if [block] should be the new head of the chain.
  @override
  Future<bool> forkChoice(B head, B block) async {
    /// Just compare total POW.
    return block.totalDifficulty + block.difficulty > head.totalDifficulty + block.difficulty;
  }
}
