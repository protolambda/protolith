

import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/tx/transaction.dart';
import 'package:protolith/blockchain/address.dart';

mixin RoutingTxData<M extends BlockMeta> on Transaction<M> {

  EthereumAddress _from;
  /// DATA, 20 Bytes - address of the sender.
  EthereumAddress get from => _from;
  set from(EthereumAddress addr) => _from = hashed(addr);
  
  EthereumAddress _to;
  /// DATA, 20 Bytes - address of the receiver. null when its a contract creation transaction.
  EthereumAddress get to => _to;
  set to(EthereumAddress addr) => _to = hashed(addr);

  int _nonce;
  /// QUANTITY - the number of transactions made by the sender prior to this one.
  int get nonce => _nonce;
  set nonce(int v) => _nonce = hashed(v);

}
