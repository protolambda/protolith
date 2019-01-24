import 'dart:async';
import 'dart:typed_data';

import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/block/data/ethash.dart';
import 'package:protolith/blockchain/block/data/extra.dart';
import 'package:protolith/blockchain/block/data/gas.dart';
import 'package:protolith/blockchain/block/data/output.dart';
import 'package:protolith/blockchain/block/data/state_change.dart';
import 'package:protolith/blockchain/block/data/ommer.dart';
import 'package:protolith/blockchain/chain/block_chain.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/standard_meta.dart';
import 'package:protolith/blockchain/receipt/tx_receipt.dart';
import 'package:protolith/blockchain/structures/trie_compound.dart';
import 'package:protolith/blockchain/tx/standard_transaction.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/crypto/sha3.dart';
import 'package:protolith/encodings/rlp/rlp_encode.dart';
import 'package:protolith/encodings/serializeables/rlp_serializable.dart';

class StandardBlock<M extends StandardBlockMeta> extends Block<M>
    with
        OutputBlockData,
        ExtraBlockData,
        OmmerBlockData,
        EthashBlockData<M>,
        GasStateBlockData,
        StateChangeBlockData<M, StandardTransaction<M>>,
        RlpEncodeable,
        RlpDecodeable {

  @override
  List<dynamic> getRlpElements() => [
    parentHash,
    ommersHash,
    beneficiary,
    stateRoot,
    transactions.root,
    receipts.root,
    logsBloom,
    difficulty,
    number,
    gasLimit,
    gasUsed,
    // 256 bits for time, as stated in the yellow paper. Because EVM.
    intAs32Bytes(timestamp),
    extraData,
    // prefer the trusted mix-hash, but use the untrusted one otherwise;
    //  we may just be computing the block-hash of an invalid block,
    //  which is fine, as long as we know it's invalid.
    trustedMixHash ?? untrustedMixHash,
    // nonce is encoded as 64 bits, not a var-size int.
    uint8View(new Uint64List.fromList([nonce]))
  ];

  @override
  List<RlpDecSetter> getRlpSetters() => [
    (v) => parentHash = Hash256.fromTypedData(v),
    (v) => ommersHash = Hash256.fromTypedData(v),
    (v) => beneficiary = EthereumAddress.fromUint8List(v),
    (v) => stateRoot = Hash256.fromTypedData(v),
    (v) => transactions = new TrieCompound<StandardTransaction<M>>([], untrustedHash: Hash256.fromTypedData(v)),
    (v) => receipts = new TrieCompound<TransactionReceipt>([], untrustedHash: Hash256.fromTypedData(v)),
    // not strictly a hash, but otherwise the same for our purposes.
    (v) => logsBloom = Hash256.fromTypedData(v),
    (v) => difficulty = v,
    (v) => number = v,
    (v) => gasLimit = v,
    (v) => gasUsed = v,
    (v) => timestamp = intFromBytes(v),
    (v) => extraData = v,
    (v) => untrustedMixHash = Hash256.fromTypedData(v),
    // nonce is encoded as 64 bits, not a var-size int.
    (v) => uint8View(new Uint64List.fromList([nonce]))
  ];

  @override
  Hash256 computeHash(M meta) {
    this.hash = sha3_256(byteView(encodeRLP(meta)));
    return this.hash;
  }

  @override
  Future validate(M pre) async {
    // TODO check validity before checking POW

    Hash256 hashOfTruncatedHeader = sha3_256(byteView(getTruncatedHeaderBytes()));

    return await verifyPOW(pre.hashimotoEpoch, hashOfTruncatedHeader);
  }

  /// Applies the implications of this block to [delta].
  @override
  Future applyToDelta(M delta) async {
    await super.applyToDelta(delta);

    await applyStateChanges(delta);
  }

  /// Get the header-bytes used to create the block,
  ///  without the mixHash and nonce.
  Uint8List getTruncatedHeaderBytes() =>
    encodeRLP([
      parentHash,
      ommersHash,
      beneficiary,
      stateRoot,
      transactions.root,
      receipts.root,
      logsBloom,
      difficulty,
      number,
      gasLimit,
      gasUsed,
      timestamp,
      extraData
    ]);

}
