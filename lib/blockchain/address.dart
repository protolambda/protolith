import 'dart:typed_data';

import 'package:chainviz_server/encodings/serializeables/uint8_list_serializeable.dart';
import 'package:web3dart/src/wallet/credential.dart' as Web3;
import 'package:pointycastle/src/utils.dart';

const int ETH_ADDRESS_BYTES = 40;

final _byteMask = new BigInt.from(0xff);

class EthereumAddress extends Web3.EthereumAddress
    implements
        Uint8ListSerializeable,
        Uint8ListDeserializeable<EthereumAddress> {

  EthereumAddress(String hex) : super(hex);

  EthereumAddress.fromNumber(BigInt number) : super.fromNumber(number);

  EthereumAddress.fromPublicKey(BigInt number) : super.fromPublicKey(number);

  @override
  Uint8List toUint8List() {
    /// When serializing, always serialize to 40 bytes,
    /// regardless if the address "fits" in 39 or lower.
    /// It's not worth the inconsistency.
    var result = new Uint8List(ETH_ADDRESS_BYTES);
    BigInt work = this.number;
    // big-endian
    for (int i = 0; i < ETH_ADDRESS_BYTES; i++) {
      result[ETH_ADDRESS_BYTES - i - 1] = (work & _byteMask).toInt();
      work = work >> 8;
    }
    return result;
  }

  @override
  EthereumAddress fromUint8List(Uint8List input) =>
      new EthereumAddress.fromNumber(decodeBigInt(input));
}
