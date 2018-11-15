import 'dart:async';
import 'dart:typed_data';

import 'package:protolith/blockchain/block/block.dart';
import 'package:protolith/blockchain/block/data/ethash.dart';
import 'package:protolith/blockchain/block/data/extra.dart';
import 'package:protolith/blockchain/block/data/gas.dart';
import 'package:protolith/blockchain/block/data/output.dart';
import 'package:protolith/blockchain/block/data/state_change.dart';
import 'package:protolith/blockchain/block/data/uncle.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/standard_meta.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/crypto/sha3.dart';
import 'package:protolith/encodings/rlp/rlp_encode.dart';

class StandardBlock<M extends StandardBlockMeta> extends Block<M>
    with
        OutputBlockData,
        ExtraBlockData,
        UncleBlockData,
        EthashBlockData,
        GasStateBlockData,
        StateChangeBlockData {

  @override
  Hash256 computeHash() {
    // TODO compute hash
    return new Hash256(new ByteData.view(new Uint8List(32).buffer));
  }

  @override
  Future<bool> validate(M meta) async {
    // TODO check validity before checking POW

    Hash256 hashOfTruncatedHeader = sha3_256(byteView(getTruncatedHeaderBytes()));

    return await verifyPOW(
        meta.hashimotoEpoch, hashOfTruncatedHeader, this.hash);
  }

  /// Get the header-bytes used to create the block,
  ///  without the mixHash and nonce.
  Uint8List getTruncatedHeaderBytes() =>
    encodeRLP([
      parentHash,
      ommersHash,
      beneficiary,
      stateRoot.hash,
      transactionsRoot.hash,
      receiptsRoot.hash,
      logsBloom,
      difficulty,
      number,
      gasLimit,
      gasUsed,
      timestamp,
      extraData
    ]);

}
