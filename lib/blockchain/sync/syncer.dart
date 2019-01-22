
import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/chain/block_chain.dart';
import 'package:protolith/blockchain/flow/inputs/blocks/provider.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/sync/peer/peer_manager.dart';

/// Keeps a [BlockChain] in sync;
/// - tries to back-fill
/// - streams new blocks into it.
class Syncer<M extends BlockMeta, B extends Block<M>, C extends BlockChain<M, B>> {

  C chain;

  PeerManager peerManager;

  // TODO write sync strategies in Mixins

}
