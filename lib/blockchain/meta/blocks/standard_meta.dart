import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/pow/ethash/epoch.dart';

class StandardBlockMeta extends BlockMeta {

  /// This holds the cache for POW verification for the block.
  HashimotoEpoch hashimotoEpoch;

  StandardBlockMeta(int blockNum) : super(blockNum);

}