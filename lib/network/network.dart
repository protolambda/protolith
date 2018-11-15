
import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/chain/blockchain.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/sync/syncer.dart';

class Network<M extends BlockMeta, B extends Block<M>, C extends BlockChain<M, B>> {

  /// Used by networks with different origins.
  /// (e.g. main-net ETH, test-net ropsten)
  final int networkID;

  C _chain;

  Syncer<M, B, C> _syncer;

  C get chain => _chain;

  Network(this.networkID);

}
