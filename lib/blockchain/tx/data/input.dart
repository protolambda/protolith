
import 'dart:typed_data';

import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/tx/transaction.dart';

mixin InputTxData<M extends BlockMeta> on Transaction<M> {

  Uint8List _input;
  /// DATA - the data send along with the transaction.
  Uint8List get input => _input;
  set input(Uint8List data) => _input = UnmodifiableUint8ListView(hashed(data));

}