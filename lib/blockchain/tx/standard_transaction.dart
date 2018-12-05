
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/blockchain/meta/blocks/standard_meta.dart';
import 'package:protolith/blockchain/tx/transaction.dart';
import 'package:protolith/blockchain/tx/data/gas.dart';
import 'package:protolith/blockchain/tx/data/input.dart';
import 'package:protolith/blockchain/tx/data/routing.dart';
import 'package:protolith/blockchain/tx/data/value.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/crypto/sha3.dart';
import 'package:protolith/encodings/rlp/rlp_encode.dart';

class StandardTransaction<M extends StandardBlockMeta> extends Transaction<M>
    with GasTxData<M>, InputTxData<M>, RoutingTxData<M>, ValueTxData<M> {

  @override
  Hash256 computeHash(M meta) {
    this.hash = sha3_256(byteView(encodeRLP([
      /// Internally we use 64 bit ints: pyEVM and Geth also ignore
      ///  the spec internally here, since it's just more efficient.
      /// For hashing we have to encode the values in 32 byte strings.
      as32Bytes(nonce),
      as32Bytes(gasPrice),
      as32Bytes(gas),
      to,
      encodeBigIntPadded(value, 32),
      input,
      as32Bytes(vrs.v),
      encodeBigIntPadded(vrs.r, 32),
      encodeBigIntPadded(vrs.s, 32)
    ])));
    return this.hash;
  }

}
