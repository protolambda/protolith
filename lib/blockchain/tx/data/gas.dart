
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/tx/transaction.dart';

mixin GasTxData<M extends BlockMeta> on Transaction<M> {

  int _gas;
  /// QUANTITY - gas provided by the sender.
  int get gas => _gas;
  set gas(int v) => _gas = hashed(v);

  int _gasPrice;
  /// QUANTITY - gas price provided by the sender in Wei.
  int get gasPrice => _gasPrice;
  set gasPrice(int price) => _gasPrice = hashed(price);

}