
import 'package:protolith/blockchain/receipt/tx_receipt.dart';

mixin GasTxReceiptData on TransactionReceipt {

  BigInt _cumulativeGasUsed;
  /// QUANTITY - The total amount of gas used when this transaction was executed in the block. (incl. this transaction)
  BigInt get cumulativeGasUsed => _cumulativeGasUsed;
  set cumulativeGasUsed(BigInt v) => _cumulativeGasUsed = hashed(v);

  BigInt _gasUsed;
  /// QUANTITY - The amount of gas used by this specific transaction alone.
  BigInt get gasUsed => _gasUsed;
  set gasUsed(BigInt price) => _gasUsed = hashed(price);

}
