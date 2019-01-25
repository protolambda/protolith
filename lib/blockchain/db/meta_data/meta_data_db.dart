
import 'dart:async';
import 'dart:typed_data';

import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/crypto/data_util.dart';

abstract class MetaDataDB {

  Stream<MetaDataKey> get keys;

  Future putData(MetaDataKey key, Uint8List value);
  Future<Uint8List> getData(MetaDataKey key);

  Future putDataset(MetaDataDB data) async {
    return await Future.wait(await data.keys.map(
            (key) async => await putData(key, await getData(key))
    ).toList());
  }

}

class MetaDataKey {

  final String kind;
  final Hash256 blockHash;
  // TODO Maybe enforce as an unmodifiable list
  final List<dynamic> path;

  MetaDataKey(this.kind, this.blockHash, [this.path]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MetaDataKey &&
              runtimeType == other.runtimeType &&
              kind == other.kind &&
              blockHash == other.blockHash &&
              ((path == null && other.path == null) ||
                  listElementwiseComparisonFn(path, other.path, (a, b) {
                    if (a is int && b is int) return a == b;
                    if (a is Uint8List && b is Uint8List) return equalUint8lists(a, b);
                    return false;
                  }));

  @override
  int get hashCode {
    // TODO Sub-optimal hashcode. Optimize later.
    int res = kind.hashCode;
    if (blockHash != null) {
      res ^= blockHash.hashCode;
    }
    if (path != null) {
      for (dynamic v in path) {
        if (v is int) res ^= v;
        else if (v is Uint8List && v.lengthInBytes >= 64) {
          res ^= byteView(v).getUint64(0);
        }
      }
    }
    return res;
  }


}