import 'package:chainviz_server/blockchain/meta/blocks/meta.dart';
import 'package:chainviz_server/blockchain/pow/ethash/epoch.dart';

class StandardBlockMeta extends BlockMeta {

  /// This holds the cache for POW verification for the block.
  HashimotoEpoch hashimotoEpoch;

  StandardBlockMeta(int blockNum) : super(blockNum);

}