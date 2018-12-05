
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/tx/transaction.dart';

mixin ValueTxData<M extends BlockMeta> on Transaction<M> {

  BigInt _value;
  /// QUANTITY - value transferred in Wei.
  BigInt get value => _value;
  set value(BigInt v) => _value = hashed(v);
}