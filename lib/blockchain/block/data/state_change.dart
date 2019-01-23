import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/receipt/tx_receipt.dart';
import 'package:protolith/blockchain/structures/trie_compound.dart';
import 'package:protolith/blockchain/tx/transaction.dart';


mixin StateChangeBlockData<M extends BlockMeta, T extends Transaction<M>> on Block<M> {

  ///DATA, 32 Bytes - the root of the state trie of the block.
  Hash256 stateRoot;

  ///Array - Compound of receipt objects.
  ///root: DATA, 32 Bytes - the root of the receipts trie of the block.
  TrieCompound<TransactionReceipt> receipts;

  ///Array - Compound of transaction objects.
  ///root: DATA, 32 Bytes - the root of the transaction trie of the block.
  TrieCompound<T> transactions;

  ///DATA, 256 Bytes - the bloom filter for the logs of the block. null when its pending block.
  /// Not strictly a hash, but also an unmodifiable 256 bit value.
  Hash256 logsBloom;

  Future applyStateChanges(M delta) async {
    // Apply all transaction changes
    // (one for one, a standard state change is strictly sequential)
    List<TransactionReceipt> receipts = [];
    for (T t in transactions.values) {
      receipts.add(await t.applyToDelta(delta));
    }
    this.receipts = new TrieCompound(receipts, untrustedHash: this.receipts?.untrustedHash);
  }

  Future verifyReceipts(M meta) async {
    // TODO verify receipts, and hook it up
  }
}
