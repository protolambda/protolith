import 'dart:typed_data';

import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/receipt/data/contract.dart';
import 'package:protolith/blockchain/receipt/data/gas.dart';
import 'package:protolith/blockchain/receipt/data/logs.dart';
import 'package:protolith/blockchain/receipt/data/routing.dart';
import 'package:protolith/blockchain/receipt/logs/log_entry.dart';
import 'package:protolith/blockchain/receipt/tx_receipt.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/encodings/serializeables/rlp_serializable.dart';

class StandardTransactionReceipt
    extends TransactionReceipt
    with
        ContractTxReceiptData,
        GasTxReceiptData,
        LogsTxReceiptData,
        RoutingTxReceiptData,
        RlpEncodeable,
        RlpDecodeable
{

  @override
  List<dynamic> getRlpElements() => [
    // TODO: pre-byzantium: state included.
    // TODO: from byzantium: status code. Included?
    cumulativeGasUsed,
    logsBloom,
    logs
  ];

  @override
  List<RlpDecSetter> getRlpSetters() => [
        (v) => contractAddress = EthereumAddress.fromUint8List(v),
        (v) => cumulativeGasUsed = decodeBigInt(v),
        (v) => logsBloom = Hash256.fromTypedData(v),
        // TODO parse log entry
        (v) => logs = v.map((l) => TransactionLogEntry()),
  ];

  @override
  Uint8List get trieData => this.encodeRLP();

}
