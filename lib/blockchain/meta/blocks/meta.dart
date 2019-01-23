
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';
import 'package:protolith/blockchain/hash.dart';

/// MetaData view of the post-state of a given block.
class BlockMeta {

  final Hash256 hash;

  final int blockNum;

  final MetaDataDB db;

  BlockMeta(this.hash, this.blockNum, this.db);

}
