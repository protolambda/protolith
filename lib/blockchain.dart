/*
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
*/