import 'dart:collection';

import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/hash.dart';

import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/crypto/sha3.dart';
import 'package:protolith/encodings/rlp/rlp_encode.dart';

mixin OmmerBlockData<M extends BlockMeta> on Block<M> {

  /// Cached ommers-hash, reset when ommer hashes change,
  ///  not computed until first use.
  Hash256 _ommersHash;

  ///DATA, 32 Bytes - SHA3 of the ommers data in the block.
  Hash256 get ommersHash =>
      _ommersHash ?? (_ommersHash = sha3_256(byteView(encodeRLP(ommers))));

  /// List of hashes of each ommer (uncle) block.
  UnmodifiableListView<Hash256> _ommers;

  ///Array - Array of ommer hashes.
  List<Hash256> get ommers => _ommers;

  set ommers(List<Hash256> v) {
    // reset cached hash
    _ommersHash = null;
    _ommers = new UnmodifiableListView(v);
  }
}
