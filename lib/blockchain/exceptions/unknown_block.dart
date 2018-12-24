import 'package:protolith/blockchain/hash.dart';

class UnknownBlockException implements Exception {

  final Hash256 blockHash;
  final String msg;

  UnknownBlockException(this.blockHash, this.msg);

  @override
  String toString() {
    return 'UnknownBlockException: $msg\nblock hash: $blockHash';
  }


}