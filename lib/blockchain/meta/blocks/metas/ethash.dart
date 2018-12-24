
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/pow/ethash/epoch.dart';

mixin EthashBlockMeta on BlockMeta {

  /// This holds the cache for POW verification for the block.
  HashimotoEpoch hashimotoEpoch;

}