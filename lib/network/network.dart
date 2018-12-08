
import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/chain/block_chain.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/sync/syncer.dart';

/// A "network" in blockchain context: it has a singalur chain,
///  and has endpoints to other systems to sync with.
/// To run a multi-chain system, one should create a class with
///  a list/map/whatever of all the smaller chain-specific networks involved.
abstract class Network<M extends BlockMeta, B extends Block<M>, C extends BlockChain<M, B>> {

  /// Used by networks with different origins.
  /// (e.g. main-net ETH, test-net ropsten)
  final int networkID;

  final C chain;

  Syncer<M, B, C> _syncer;

  Network(this.networkID, this.chain) {
    _syncer = createSyncer();
  }

  /// Creates a syncer instance that will keep the chain of this network up to date.
  Syncer<M, B, C> createSyncer();

  // TODO: read sync progress etc.
}
