
class BlockMeta {

  int blockNum;

  BlockMeta clone() {
    return new BlockMeta()..blockNum = blockNum;
  }

}