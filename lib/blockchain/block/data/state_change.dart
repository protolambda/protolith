
import 'package:chainviz_server/blockchain/hash.dart';
import 'package:chainviz_server/blockchain/structures/merkle_tree.dart';
import 'package:chainviz_server/blockchain/tx/tx_compound.dart';

class StateChangeBlockData {

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
