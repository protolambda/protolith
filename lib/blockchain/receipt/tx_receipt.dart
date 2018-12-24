import 'dart:typed_data';

import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/mixins/lazy_hashed.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/crypto/merkle_patricia.dart' as MP;

class TransactionReceipt with LazyHashed<Hash256>, MP.TrieValue {

  Hash256 _transactionHash;
  /// DATA, 32 Bytes - hash of the transaction.
  Hash256 get transactionHash => _transactionHash;
  set transactionHash(Hash256 v) => _transactionHash = hashed(v);

  int _transactionIndex;
  /// QUANTITY - integer of the transaction's index position in the block.
  int get transactionIndex => _transactionIndex;
  set transactionIndex(int v) => _transactionIndex = hashed(v);

  Hash256 _blockHash;
  /// DATA, 32 Bytes - hash of the block where this transaction was in.
  Hash256 get blockHash => _blockHash;
  set blockHash(Hash256 v) => _blockHash = hashed(v);

  int _blockNumber;
  /// QUANTITY - block number where this transaction was in.
  int get blockNumber => _blockNumber;
  set blockNumber(int v) => _blockNumber = hashed(v);

  @override
  Uint8List get trieData => null;

  @override
  Uint8List get trieKey => encodeInt(transactionIndex);

}
