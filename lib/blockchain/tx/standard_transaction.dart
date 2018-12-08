
import 'package:protolith/blockchain/address.dart';
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
import 'package:protolith/encodings/serializeables/rlp_serializable.dart';

class StandardTransaction<M extends StandardBlockMeta> extends Transaction<M>
    with GasTxData<M>, InputTxData<M>, RoutingTxData<M>, ValueTxData<M>,
        RlpEncodeable,
        RlpDecodeable {

  @override
  List<dynamic> getRlpElements() => [
    /// Internally we use 64 bit ints: pyEVM and Geth also ignore
    ///  the spec internally here, since it's just more efficient.
    /// For hashing we have to encode the values in <= 32 byte strings.
    nonce,
    gasPrice,
    gas,
    to,
    encodeBigInt(value),
    input,
    vrs.v,
    encodeBigInt(vrs.r),
    encodeBigInt(vrs.s)
  ];

  @override
  List<RlpDecSetter> getRlpSetters() => [
    (v) => nonce = intFrom32Bytes(v),
    (v) => gasPrice = intFrom32Bytes(v),
    (v) => gas = intFrom32Bytes(v),
    (v) => to = new EthereumAddress.fromUint8List(v),
    (v) => value = decodeBigInt(v),
    (v) => input = v,
    // gradually complete the VRS object: not as efficient,
    // but the RLP decode interface can handle elements independent of each other this way.
    (x) => vrs = MsgSignature(this.vrs?.r ?? BigInt.from(0), this.vrs?.s ?? BigInt.from(0), intFrom32Bytes(x)),
    (x) => vrs = MsgSignature(decodeBigInt(x), this.vrs?.s ?? BigInt.from(0), this.vrs?.v ?? 0),
    (x) => vrs = MsgSignature(this.vrs?.r ?? BigInt.from(0), decodeBigInt(x), this.vrs?.v ?? 0)
  ];

  @override
  Hash256 computeHash(M meta) {
    this.hash = sha3_256(byteView(this.encodeRLP()));
    return this.hash;
  }

}
