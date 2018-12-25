
import 'dart:typed_data';

import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';
import 'package:protolith/crypto/data_util.dart';

class Key {
  Uint8List key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Key
              && runtimeType == other.runtimeType
              && equalUint8lists(key, other.key));

  @override
  int get hashCode => byteView(key).getUint64(0);

  Key(this.key);

}

class Level {

}

class Compound extends Level {

  Map<Key, Level> data;

}

class Value extends Level {

  Uint8List value;

}

/// In-memory DB implementation. For testing/experimentation.
/// Basically a recursive map, with support for mixed level
///  types (i.e. more nesting, or a value).
class InMemoryMetaDataDB extends MetaDataDB {

  Map<String, Compound> _dbs;

  @override
  Future<Uint8List> getData(MetaDataKey key) async {
    Compound c = _dbs[key.kind];
    if (c == null) return null;
    Level lvl = c;
    for (Uint8List k in key.path) {
      if (lvl == null) return null;
      else if (lvl is Compound) {
        lvl = (lvl as Compound).data[Key(k)];
      } else {
        throw Exception("Key path too long.");
      }
    }
    if (lvl is Value) {
      return lvl.value;
    } else {
      throw Exception("Incomplete key.");
    }
  }

  @override
  Future putData(MetaDataKey key, Uint8List value) async {
    Compound c = _dbs[key.kind];
    if (c == null) {
      c = _dbs[key.kind] = new Compound();
    }
    Compound p = c;
    Level lvl = null;
    for (int i = 0; i < key.path.length; i++) {
      Uint8List k = key.path[i];
      if (lvl != null) {
        if (lvl is Compound) {
          p = lvl;
          lvl = null;
        } else {
          throw Exception("Key path too long.");
        }
      }
      lvl = p.data[Key(k)];
      if (lvl == null) {
        p.data[Key(k)] = lvl = (i == key.path.length - 1) ? new Value() : new Compound();
      }
    }
    if (lvl is Value) {
      lvl.value = value;
    } else {
      throw Exception("Incomplete key.");
    }
  }

}