
import 'package:chainviz_server/blockchain/block/block.dart';
import 'package:chainviz_server/blockchain/chain/blockchain.dart';
import 'package:chainviz_server/blockchain/flow/inputs/blocks/provider.dart';
import 'package:chainviz_server/blockchain/meta/blocks/meta.dart';

/// Keeps a [BlockChain] in sync;
/// - tries to back-fill
/// - streams new blocks into it.
class Syncer<M extends BlockMeta, B extends Block<M>, C extends BlockChain<M, B>> {

  C chain;

  List<BlockProvider> blockProviders;

  // TODO map provided data into chain,
  // and send back-fill requests to the providers when necessary.
}
