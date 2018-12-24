
import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/receipt/tx_receipt.dart';

mixin RoutingTxReceiptData on TransactionReceipt {

  EthereumAddress _from;
  /// DATA, 20 Bytes - address of the sender.
  EthereumAddress get from => _from;
  set from(EthereumAddress v) => _from = hashed(v);

  EthereumAddress _to;
  /// DATA, 20 Bytes - address of the receiver. null when it's a contract creation transaction.
  EthereumAddress get to => _to;
  set to(EthereumAddress v) => _to = hashed(v);

}
