import 'dart:typed_data';
import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';

mixin ExtraBlockData<M extends BlockMeta> on Block<M> {
  ///DATA - the "extra data" field of this block, 32 bytes
  Uint8List extraData;
}
