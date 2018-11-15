
import 'package:protolith/blockchain/block/standard_block.dart';
import 'package:protolith/blockchain/chain/blockchain.dart';
import 'package:protolith/blockchain/meta/blocks/standard_meta.dart';
import 'package:protolith/blockchain/sync/syncer.dart';
import 'package:protolith/network/network.dart';

class StandardNetwork<M extends StandardBlockMeta, B extends StandardBlock<M>, C extends BlockChain<M, B>> extends Network<M, B, C> {

  /// Used by split networks (e.g. ETH-ETC)
  final int chainID;

  C _chain;

  Syncer<M,B,C> _syncer;

  C get chain => _chain;


  StandardNetwork(int networkID, this.chainID) : super(networkID);

}
