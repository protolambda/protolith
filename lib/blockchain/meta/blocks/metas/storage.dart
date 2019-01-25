
import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';

mixin StorageBlockMeta on BlockMeta {

  Future<Hash256> getStorageData(EthereumAddress address, Hash256 k) =>
      db.getData(MetaDataKey("storage", blockHash, [address.toUint8List(), k.uint8list])).then((b) => Hash256.fromTypedData(b));

  Future setStorageData(EthereumAddress address, Hash256 k, Hash256 v) =>
      db.putData(MetaDataKey("storage", blockHash, [address.toUint8List(), k.uint8list]), v.uint8list);

}