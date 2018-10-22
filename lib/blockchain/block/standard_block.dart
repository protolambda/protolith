
import 'dart:async';
import 'dart:typed_data';

import 'package:chainviz_server/blockchain.dart';
import 'package:chainviz_server/blockchain/block/block.dart';
import 'package:chainviz_server/blockchain/block/data/ethash.dart';
import 'package:chainviz_server/blockchain/block/data/extra.dart';
import 'package:chainviz_server/blockchain/block/data/gas.dart';
import 'package:chainviz_server/blockchain/block/data/output.dart';
import 'package:chainviz_server/blockchain/block/data/state_change.dart';
import 'package:chainviz_server/blockchain/block/data/uncle.dart';
import 'package:chainviz_server/blockchain/hash.dart';

class StandardBlock extends Block with OutputBlockData, ExtraBlockData, UncleBlockData, EthashBlockData, GasStateBlockData, StateChangeBlockData {

  @override
  Hash256 computeHash() {
    // TODO compute hash
    return new Hash256(new ByteData.view(new Uint8List(32).buffer));
  }

  @override
  Future<bool> validate(BlockChain chain) async {
    // TODO check validity
    return false; // (await checkBlock()) && (await this.verifyPOW());
  }

}
