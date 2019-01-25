
import 'dart:typed_data';

import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/tx/standard_transaction.dart';
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';

mixin CodeBlockMeta<T extends StandardTransaction> on BlockMeta {

  Future<Uint8List> getCode(EthereumAddress address) =>
    db.getData(MetaDataKey("code", blockHash, [address.toUint8List()]));

  Future setCode(EthereumAddress address, Uint8List code) =>
    db.putData(MetaDataKey("code", blockHash, [address.toUint8List()]), code);

}
