import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/meta/blocks/metas/ethash.dart';
import 'package:protolith/blockchain/meta/blocks/metas/code.dart';
import 'package:protolith/blockchain/meta/blocks/metas/height.dart';
import 'package:protolith/blockchain/meta/blocks/metas/storage.dart';
import 'package:protolith/blockchain/meta/blocks/metas/nonce.dart';
import 'package:protolith/blockchain/meta/blocks/metas/value.dart';

class StandardBlockMeta extends BlockMeta
    with
        EthashBlockMeta,
        CodeBlockMeta,
        HeightBlockMeta,
        StorageBlockMeta,
        NonceBlockMeta,
        ValueBlockMeta {

  StandardBlockMeta(Hash256 hash, int blockNum, MetaDataDB db)
      : super(hash, db) {
    this.blockNum = blockNum;
  }

}
