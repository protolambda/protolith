
import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';

mixin NonceBlockMeta on BlockMeta {

  Future<int> getNonce(EthereumAddress address) =>
      db.getData(MetaDataKey("nonce", [address.toUint8List()])).then(intFromBytes);

  Future setNonce(EthereumAddress address, int nonce) =>
      db.putData(MetaDataKey("nonce", [address.toUint8List()]), encodeInt(nonce));

}