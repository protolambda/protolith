
import 'package:chainviz_server/blockchain/structures/merkle_tree.dart';
import 'package:chainviz_server/blockchain/transaction.dart';

class TransactionCompound {

  List<Transaction> transactions;

  MerkleTreeNode root;

}