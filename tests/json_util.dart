import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:protolith/blockchain/address.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/blockchain/hash.dart';

Hash256 decodeJSONHash256(String value) => Hash256.fromTypedData(
    new Uint8List.fromList(hex.decode(value.replaceFirst("0x", ""))));

String encodeJSONHash256(Hash256 value) => "0x" + hex.encode(value.uint8list);

Uint8List decodeJSONUint8List(String value) =>
    new Uint8List.fromList(hex.decode(value.replaceFirst("0x", "")));

String encodeJSONUint8List(Uint8List value) => "0x" + hex.encode(value);

EthereumAddress decodeJSONAddress(String value) => EthereumAddress(value);

String encodeJSONAddress(EthereumAddress value) => value.hex;

BigInt decodeJSONBigInt(String value) =>
    decodeBigInt(hex.decode((value.length % 2 == 0 ? "" : "0") + value.replaceFirst("0x", "")));

String encodeJSONBigInt(BigInt value) => "0x" + hex.encode(encodeBigInt(value));

int decodeJSONInt(String value) => int.parse(value.replaceFirst("0x", ""), radix: 16);

String encodeJSONInt(int value) => "0x" + hex.encode(encodeInt(value));
