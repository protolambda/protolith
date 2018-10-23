import 'dart:async';

import 'package:chainviz_server/blockchain/block/block.dart';
import 'package:chainviz_server/blockchain/block/standard_block.dart';
import 'package:chainviz_server/blockchain/chain/blockchain.dart';
import 'package:chainviz_server/blockchain/flow/inputs/blocks/provider.dart';
import 'package:chainviz_server/blockchain/meta/blocks/standard_meta.dart';

class FakeBlockProvider extends BlockProvider<StandardBlock> {

  final BlockChain<StandardBlockMeta, StandardBlock> _chain;

  FakeBlockProvider(this._chain) {
    new Timer.periodic(const Duration(seconds: 10), (_) {
      _newBlock().then(this.blocksCtrl.add);
    });
  }

  Future<Block> _newBlock() async {
    int time = new DateTime.now().millisecondsSinceEpoch;
    StandardBlock previous = await _chain.lastBlock;
    // TODO improve debug block creation
    return StandardBlock()
      ..timestamp = time
      ..number = previous.number + 1
      ..parentHash = previous.hash;
  }

}