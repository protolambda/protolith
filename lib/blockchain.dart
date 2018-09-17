import 'dart:async';

class Network {

  final int networkID;
  final int chainID;

  final BlockChain chain;

  BlockProvider _provider;

  Network(this.networkID, this.chainID, this._provider)
      : chain = BlockChain(networkID, chainID) {
    _provider.blocks.listen(chain.addBlock);
  }

}

class FakeBlockProvider extends BlockProvider<EthereumBlock> {

  final BlockChain _chain;

  FakeBlockProvider(this._chain) {
    new Timer.periodic(const Duration(seconds: 10), (_) {
      _newBlock().then(this._blocksCtrl.add);
    });
  }

  Future<Block> _newBlock() async {
    int time = new DateTime.now().millisecondsSinceEpoch;
    EthereumBlock previous = await _chain.lastBlock;
    // TODO improve debug block creation
    return EthereumBlock()
      ..timestamp = time
      ..number = previous.number + 1
      ..parentHash = previous.hash;
  }

}

class BlockProvider<B extends Block> {

  StreamController<B> _blocksCtrl = new StreamController.broadcast();

  Stream<B> get blocks => _blocksCtrl.stream;

}

class InMemoryBlockDB<B extends Block> extends BlockDB<B> {

  Map<BlockHash, Block> byHash = {};
  Map<int, Set<BlockHash>> byNumber = {};

  @override
  Future putBlock(B block) async {
    byNumber.putIfAbsent(block.number, () => new Set()).add(block.hash);
    byHash[block.hash] = block;
  }

  @override
  Future<B> getBlockByHash(BlockHash hash) async => byHash[hash];

  @override
  Future<Set<BlockHash>> getBlocksByNumber(int number) async => byNumber[number];

  @override
  Future<B> deleteBlock(BlockHash hash) async {
    Block block = byHash.remove(hash);
    if (block != null) byNumber[block.number]?.remove(block);
    return block;
  }

}

abstract class BlockDB<B extends Block> {

  Future putBlock(B block);

  Future<B> getBlockByHash(BlockHash hash);
  Future<Set<BlockHash>> getBlocksByNumber(int number);

  Future<B> deleteBlock(BlockHash block);

}

class BlockChain<B extends Block> {

  /// Used by networks with different origins.
  /// (e.g. main-net ETH, test-net ropsten)
  final int networkID;

  /// Used by split networks (e.g. ETH-ETC)
  final int chainID;

  int blockHeight = 0;

  Future<B> get lastBlock async {
    BlockHash hash = (await db.getBlocksByNumber(blockHeight))?.first;
    if (hash != null) return await db.getBlockByHash(hash);
    return null;
  }

  BlockDB db;

  BlockChain(this.networkID, this.chainID);

  Future<B> getBlock(BlockHash hash) {
    return db.getBlockByHash(hash);
  }

  Future addBlock(B block) async {
    if (await block.validate(this)) {
      await db.putBlock(block);
    }
  }

}

class BlockHash {

  /// Lowercase hex format, no prefix
  final String hex;

  BlockHash(this.hex);

}

class EthereumBlock extends Block with OutputBlockData, ExtraBlockData, UncleBlockData, POWBlockData, GasStateBlockData, StateChangeBlockData {

  @override
  BlockHash computeHash() {
    String hex = "";
    // TODO compute hash of block
    return new BlockHash(hex);
  }

  @override
  Future<bool> validate(BlockChain chain) async {
    // TODO check validity
    return /* (await checkBlock()) && */ (await verifyPOW());
  }

}

abstract class Block {

  /// QUANTITY - the block number. null when its pending block.
  int number;
  
  ///QUANTITY - the unix timestamp for when the block was collated.
  int timestamp;

  BlockHash _hash;

  /// DATA, 32 Bytes - hash of the block. null when its pending block.
  BlockHash get hash => _hash ?? (_hash = computeHash());

  /// DATA, 32 Bytes - hash of the parent block.
  BlockHash parentHash;

  BlockHash computeHash();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Block &&
              runtimeType == other.runtimeType &&
              hash == other.hash;

  @override
  int get hashCode => hash.hashCode;

  Future<bool> validate(BlockChain chain);

}

class ExtraBlockData {

  ///DATA - the "extra data" field of this block.
  dynamic extraData;

}

class OutputBlockData {

  ///QUANTITY - integer the size of this block in bytes.
  int size;
  
}

class UncleBlockData {

  ///DATA, 32 Bytes - SHA3 of the uncles data in the block.
  Sha3Hash sha3Uncles;

  ///Array - Array of uncle hashes.
  List<BlockHash> uncles;
  
}

class POWBlockData {

  ///DATA, 8 Bytes - hash of the generated proof-of-work. null when its pending block.
  Nonce nonce;

  ///DATA, 20 Bytes - the address of the beneficiary to whom the mining rewards were given.
  Address miner;

  ///QUANTITY - integer of the difficulty for this block.
  int difficulty;

  ///QUANTITY - integer of the total difficulty of the chain until this block.
  int totalDifficulty;

  Future<bool> verifyPOW() async {
    // TODO verify
    return true;
  }
}

class GasStateBlockData {

  ///QUANTITY - the maximum gas allowed in this block.
  int gasLimit;

  ///QUANTITY - the total used gas by all transactions in this block.
  int gasUsed;

}

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
  dynamic logsBloom;

}

class TransactionCompound {

  List<Transaction> transactions;

  MerkleTreeNode root;

}

class Nonce {

}

class Sha3Hash {

}

class BlockHeader {

  BlockHash prevBlock;

}

class Transaction {

  /// DATA, 32 Bytes - hash of the block where this transaction was in. null when its pending.
  final BlockHash blockHash;
  /// QUANTITY - block number where this transaction was in. null when its pending.
  final int blockNumber;
  /// DATA, 20 Bytes - address of the sender.
  final Address from;
  /// QUANTITY - gas provided by the sender.
  final int gas;
  /// QUANTITY - gas price provided by the sender in Wei.
  final int gasPrice;
  /// DATA, 32 Bytes - hash of the transaction.
  final Sha3Hash hash;
  /// DATA - the data send along with the transaction.
  final dynamic input;
  /// QUANTITY - the number of transactions made by the sender prior to this one.
  final int nonce;
  /// DATA, 20 Bytes - address of the receiver. null when its a contract creation transaction.
  final Address to;
  /// QUANTITY - integer of the transactions index position in the block. null when its pending.
  final int transactionIndex;
  /// QUANTITY - value transferred in Wei.
  final int value;
  /// ECDSA values.
  final ECDSAData vrs;
}

class ECDSAData {
  /// QUANTITY - ECDSA recovery id
  final int v;
  /// DATA, 32 Bytes - ECDSA signature r
  final int r;
  /// DATA, 32 Bytes - ECDSA signature s
  final int s;
}

class MerkleTreeNode {

}

class MerkleTree {

}

class Address {

}

