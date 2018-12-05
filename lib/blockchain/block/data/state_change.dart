import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/structures/merkle_tree.dart';
import 'package:protolith/blockchain/tx/tx_compound.dart';

mixin StateChangeBlockData<M extends BlockMeta> on Block<M> {

  ///DATA, 32 Bytes - the root of the transaction trie of the block.
  MerkleTreeNode get transactionsRoot => transactions.root;

  ///DATA, 32 Bytes - the root of the state trie of the block.
  MerkleTreeNode stateRoot;

  ///DATA, 32 Bytes - the root of the receipts trie of the block.
  MerkleTreeNode receiptsRoot;

  ///Array - Array of transaction objects.
  TransactionCompound transactions;

  ///DATA, 256 Bytes - the bloom filter for the logs of the block. null when its pending block.
  /// Not strictly a hash, but also an unmodifiable 256 bit value.
  Hash256 logsBloom;

}
