import 'dart:typed_data';

import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/encodings/serializeables/uint8_list_serializeable.dart';
import 'package:web3dart/src/wallet/credential.dart' as Web3;
import 'package:pointycastle/src/utils.dart';

const int ETH_ADDRESS_BYTES = 40;

class EthereumAddress extends Web3.EthereumAddress
    implements
        Uint8ListSerializeable,
        Uint8ListDeserializeable<EthereumAddress> {

  EthereumAddress(String hex) : super(hex);

  EthereumAddress.fromNumber(BigInt number) : super.fromNumber(number);

  EthereumAddress.fromPublicKey(BigInt number) : super.fromPublicKey(number);

  @override
  Uint8List toUint8List() => encodeBigIntPadded(this.number, ETH_ADDRESS_BYTES);

  @override
  EthereumAddress fromUint8List(Uint8List input) =>
      new EthereumAddress.fromNumber(decodeBigInt(input));
}
