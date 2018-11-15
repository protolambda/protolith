
import 'package:protolith/blockchain/structures/merkle_tree.dart';
import 'package:protolith/blockchain/tx/transaction.dart';

class TransactionCompound {

  List<Transaction> transactions;

  MerkleTreeNode root;

}