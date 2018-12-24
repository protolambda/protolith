
import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/tx/standard_transaction.dart';

mixin CodeBlockMeta<T extends StandardTransaction> on BlockMeta {

  BigInt getCode(EthereumAddress address) {

  }

}
