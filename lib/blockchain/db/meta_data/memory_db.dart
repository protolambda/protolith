
import 'dart:typed_data';

import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';


/// In-memory DB implementation. For testing/experimentation.
/// And for small changes (e.g. temporary storage during block processing).
/// Basically a map with complex keys.
class InMemoryMetaDataDB extends MetaDataDB {

  Map<MetaDataKey, Uint8List> _db;

  Stream<MetaDataKey> get keys => new Stream.fromIterable(_db.keys);

  @override
  Future<Uint8List> getData(MetaDataKey key) async => _db[key];

  @override
  Future putData(MetaDataKey key, Uint8List value) async {
    _db[key] = value;
  }

}