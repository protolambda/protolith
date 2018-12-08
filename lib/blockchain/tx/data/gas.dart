
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/tx/transaction.dart';

mixin GasTxData<M extends BlockMeta> on Transaction<M> {

  BigInt _gas;
  /// QUANTITY - gas provided by the sender.
  BigInt get gas => _gas;
  set gas(BigInt v) => _gas = hashed(v);

  BigInt _gasPrice;
  /// QUANTITY - gas price provided by the sender in Wei.
  BigInt get gasPrice => _gasPrice;
  set gasPrice(BigInt price) => _gasPrice = hashed(price);

}