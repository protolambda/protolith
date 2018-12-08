import 'dart:async';

import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/block/standard_block.dart';
import 'package:protolith/blockchain/chain/block_chain.dart';
import 'package:protolith/blockchain/flow/inputs/blocks/provider.dart';
import 'package:protolith/blockchain/meta/blocks/standard_meta.dart';

class FakeBlockProvider extends BlockProvider<StandardBlock> {

  final BlockChain<StandardBlockMeta, StandardBlock> _chain;

  List<Block> _createdBlocks = [];

  final int blockTime;

  FakeBlockProvider(this._chain, {this.blockTime: 10}) {
    new Timer.periodic(new Duration(seconds: blockTime), (_) {
      _newBlock().then(this.blocksCtrl.add);
    });
  }

  Future<Block> _newBlock() async {
    int time = new DateTime.now().millisecondsSinceEpoch;
    StandardBlock previous = await _chain.lastBlock;
    // TODO improve debug block creation
    StandardBlock block = StandardBlock()
      ..timestamp = time
      ..number = previous.number + 1
      ..parentHash = previous.hash;
    _createdBlocks.add(block);
    return block;
  }

  @override
  Future<bool> requestBlocks(int startHeight, int endHeight) async {
    // TODO create blocks if not already created earlier.
    // Then push them to the block subscription.
  }

}