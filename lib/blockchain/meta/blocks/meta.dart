
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';

class BlockMeta {

  int blockNum;

  MetaDataDB db;

  BlockMeta clone() {
    // TODO: clone DB?
    return new BlockMeta()..blockNum = blockNum;
  }

}