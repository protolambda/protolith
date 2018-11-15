import 'dart:typed_data';

import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/crypto/ecdsa.dart';

class Transaction {

  /// DATA, 32 Bytes - hash of the block where this transaction was in. null when its pending.
  final Hash256 blockHash;

  /// QUANTITY - block number where this transaction was in. null when its pending.
  final int blockNumber;

  /// DATA, 20 Bytes - address of the sender.
  final EthereumAddress from;

  /// QUANTITY - gas provided by the sender.
  final int gas;

  /// QUANTITY - gas price provided by the sender in Wei.
  final int gasPrice;

  /// DATA, 32 Bytes - hash of the transaction.
  final Uint8List hash;

  /// DATA - the data send along with the transaction.
  final dynamic input;

  /// QUANTITY - the number of transactions made by the sender prior to this one.
  final int nonce;

  /// DATA, 20 Bytes - address of the receiver. null when its a contract creation transaction.
  final EthereumAddress to;

  /// QUANTITY - integer of the transactions index position in the block. null when its pending.
  final int transactionIndex;

  /// QUANTITY - value transferred in Wei.
  final int value;

  /// ECDSA values.
  final MsgSignature vrs;

  Transaction(
      this.blockHash,
      this.blockNumber,
      this.from,
      this.gas,
      this.gasPrice,
      this.hash,
      this.input,
      this.nonce,
      this.to,
      this.transactionIndex,
      this.value,
      this.vrs);
}
