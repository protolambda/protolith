import 'dart:async';

import 'package:chainviz_server/blockchain/block/block.dart';

class BlockProvider<B extends Block> {

  /// Used to feed the stream of blocks
  StreamController<B> blocksCtrl = new StreamController.broadcast();

  Stream<B> get blocks => blocksCtrl.stream;

}
