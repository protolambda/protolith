
import 'package:chainviz_server/blockchain/block/block.dart';
import 'package:chainviz_server/blockchain/chain/blockchain.dart';
import 'package:chainviz_server/blockchain/meta/blocks/meta.dart';
import 'package:chainviz_server/blockchain/sync/syncer.dart';

class Network<M extends BlockMeta, B extends Block<M>, C extends BlockChain<M, B>> {

  /// Used by networks with different origins.
  /// (e.g. main-net ETH, test-net ropsten)
  final int networkID;

  C _chain;

  Syncer<M, B, C> _syncer;

  C get chain => _chain;

  Network(this.networkID);

}
