
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/receipt/logs/log_entry.dart';
import 'package:protolith/blockchain/receipt/tx_receipt.dart';

mixin LogsTxReceiptData on TransactionReceipt {

  List<TransactionLogEntry> _logs;
  ///  Array - Array of log objects, which this transaction generated.
  List<TransactionLogEntry> get logs => _logs;
  set logs(List<dynamic> v) => _logs = hashed(v);

  Hash256 _logsBloom;
  /// DATA, 256 Bytes - Bloom filter for light clients to quickly retrieve related logs.
  Hash256 get logsBloom => _logsBloom;
  set logsBloom(Hash256 v) => _logsBloom = hashed(v);

  // TODO tx logs

  // TODO logs bloom

}
