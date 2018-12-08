
import 'package:protolith/blockchain/block/standard_block.dart';
import 'package:protolith/blockchain/chain/standard_block_chain.dart';
import 'package:protolith/blockchain/meta/blocks/standard_meta.dart';
import 'package:protolith/blockchain/sync/syncer.dart';
import 'package:protolith/network/network.dart';

class StandardNetwork<M extends StandardBlockMeta, B extends StandardBlock<M>, C extends StandardBlockChain<M, B>> extends Network<M, B, C> {

  /// Used by split networks (e.g. ETH-ETC). Different from networkID.
  final int chainID;

  StandardNetwork(int networkID, this.chainID, C chain) : super(networkID, chain);

  @override
  Syncer<M, B, C> createSyncer() {
    // TODO: add block provider(s) to syncer, and initialize it with this.chain.
    return new Syncer();
  }

}
