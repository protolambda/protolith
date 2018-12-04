import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/meta/blocks/metas/ethash.dart';

class StandardBlockMeta extends BlockMeta with EthashBlockMeta {

  StandardBlockMeta(int blockNum) : super(blockNum);

}