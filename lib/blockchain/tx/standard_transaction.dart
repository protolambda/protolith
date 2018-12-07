
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/standard_meta.dart';
import 'package:protolith/blockchain/tx/transaction.dart';
import 'package:protolith/blockchain/tx/data/gas.dart';
import 'package:protolith/blockchain/tx/data/input.dart';
import 'package:protolith/blockchain/tx/data/routing.dart';
import 'package:protolith/blockchain/tx/data/value.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/crypto/ecdsa.dart';
import 'package:protolith/crypto/sha3.dart';
import 'package:protolith/encodings/rlp/rlp_encode.dart';
import 'package:protolith/encodings/serializeables/rlp_serializable.dart';

class StandardTransaction<M extends StandardBlockMeta> extends Transaction<M>
    with GasTxData<M>, InputTxData<M>, RoutingTxData<M>, ValueTxData<M>,
        RlpEncodeable,
        RlpDecodeable {

  @override
  List<dynamic> getRlpElements() => [
    /// Internally we use 64 bit ints: pyEVM and Geth also ignore
    ///  the spec internally here, since it's just more efficient.
    /// For hashing we have to encode the values in 32 byte strings.
    intAs32Bytes(nonce),
    intAs32Bytes(gasPrice),
    intAs32Bytes(gas),
    to,
    encodeBigIntPadded(value, 32),
    input,
    intAs32Bytes(vrs.v),
    encodeBigIntPadded(vrs.r, 32),
    encodeBigIntPadded(vrs.s, 32)
  ];

  @override
  List<RlpDecSetter> getRlpSetters() => [
    (v) => nonce = intFrom32Bytes(v),
    (v) => gasPrice = intFrom32Bytes(v),
    (v) => gas = intFrom32Bytes(v),
    (v) => to = v,
    (v) => value = decodeBigInt(v),
    (v) => input = v,
    // gradually complete the VRS object: not as efficient,
    // but the RLP decode interface can handle elements independent of each other this way.
    (v) => vrs = MsgSignature(this.vrs.r ?? 0, this.vrs.s ?? 0, intFrom32Bytes(v)),
    (v) => vrs = MsgSignature(this.vrs.r ?? decodeBigInt(v), this.vrs.s ?? 0, this.vrs.v ?? 0),
    (v) => vrs = MsgSignature(this.vrs.r ?? 0, this.vrs.s ?? decodeBigInt(v), this.vrs.v ?? 0)
  ];

  @override
  Hash256 computeHash(M meta) {
    this.hash = sha3_256(byteView(encodeRLP(meta)));
    return this.hash;
  }

}
