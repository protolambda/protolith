import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/receipt/tx_receipt.dart';

mixin ContractTxReceiptData on TransactionReceipt {

  EthereumAddress _contractAddress;

  /// DATA, 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise null.
  EthereumAddress get contractAddress => _contractAddress;

  set contractAddress(EthereumAddress v) => _contractAddress = hashed(v);

}
