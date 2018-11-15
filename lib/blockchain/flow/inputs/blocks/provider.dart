import 'dart:async';

import 'package:protolith/blockchain/block/block.dart';

abstract class BlockProvider<B extends Block> {

  /// Used to feed the stream of blocks
  StreamController<B> blocksCtrl = new StreamController.broadcast();

  Stream<B> get blocks => blocksCtrl.stream;

  /// Returns a future that completes with an acknowledgement
  ///  of the provider to handle the request.
  Future<bool> requestBlocks(int startHeight, int endHeight);

}
