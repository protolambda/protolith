import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/crypto/ecdsa.dart';
import 'package:protolith/blockchain/mixins/lazy_hashed.dart';

abstract class Transaction<M extends BlockMeta> with LazyHashed<Hash256> {

  Hash256 _blockHash;
  /// DATA, 32 Bytes - hash of the block where this transaction was in. null when its pending.
  Hash256 get blockHash => _blockHash;
  set blockHash(Hash256 h) => _blockHash = hashed(h);


  int _blockNumber;
  /// QUANTITY - block number where this transaction was in. null when its pending.
  int get blockNumber => _blockNumber;
  set blockNumber(int n) => _blockNumber = hashed(n);


  int _transactionIndex;
  /// QUANTITY - integer of the transactions index position in the block. null when its pending.
  int get transactionIndex => _transactionIndex;
  set transactionIndex(int i) => _transactionIndex = hashed(i);


  MsgSignature _vrs;
  /// ECDSA values.
  MsgSignature get vrs => _vrs;
  set vrs(MsgSignature addr) => _vrs = hashed(addr);

  /// Compute the block-hash: this is the hash
  ///  of the full RLP encoded header.
  Hash256 computeHash(M meta);

}
