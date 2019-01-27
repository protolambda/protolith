
import 'package:protolith/blockchain/meta/blocks/meta.dart';

mixin HeightBlockMeta on BlockMeta {

  // Not stored, as this can be derived from the block the meta is created from.
  // Set in the meta initialization.
  int blockNum;

}
