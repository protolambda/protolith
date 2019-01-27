import 'dart:async';

import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/mixins/lazy_hashed.dart';

abstract class Block<M extends BlockMeta> with LazyHashed<Hash256> {

  /// DATA, 32 Bytes - hash of the block. null when its pending block.
  Hash256 get hash => super.hash;

  /// DATA, 32 Bytes - hash of the parent block.
  Hash256 parentHash;

  /// Compute the block-hash: this is the hash
  ///  of the full RLP encoded header.
  Hash256 computeHash(M meta);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Block && runtimeType == other.runtimeType && hash == other.hash;

  @override
  int get hashCode => hash.hashCode;

  /// Future, throws if invalid
  Future validate(M pre) async {
    // To override in any sub-class.
    // Then call super.validate(pre) to keep behaviour of other mixins.
    if (pre.blockHash != parentHash)
      throw Exception(
          "Cannot validatore block with parent-hash ${parentHash}, supplied pre-meta has different hash: ${pre.blockHash}");
  }

  /// Applies the implications of this block to [delta],
  ///  a meta data DB view of the post-state of the parent block of this block,
  ///  storing every change, to be finalized once the block processing is done
  ///  (i.e. hash is known).
  Future applyToDelta(M delta) async {
    // Implementation up to sub classes / mixins.
  }
}
