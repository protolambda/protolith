
import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';

mixin ValueBlockMeta on BlockMeta {

  Future<BigInt> getBalance(EthereumAddress address) =>
      db.getData(MetaDataKey("balance", hash, [address.toUint8List()])).then(decodeBigInt);

  Future setBalance(EthereumAddress address, BigInt value) =>
      db.putData(MetaDataKey("balance", hash, [address.toUint8List()]), encodeBigInt(value));

}
