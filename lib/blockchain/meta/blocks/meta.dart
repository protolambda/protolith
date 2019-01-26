
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';
import 'package:protolith/blockchain/hash.dart';

/// MetaData view of the post-state of a given block.
class BlockMeta {

  final Hash256 blockHash;

  final int blockNum;

  final MetaDataDB db;

  BlockMeta(this.blockHash, this.blockNum, this.db);


  Future genesis() async {
    // To override in any sub-class.
    // Then call super.genesis() to keep behaviour of other mixins.
  }
}
