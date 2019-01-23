
import 'dart:typed_data';
import 'package:async/async.dart' show StreamGroup;
import 'package:protolith/blockchain/db/meta_data/meta_data_db.dart';


/// Delta DB, puts everything new in a change-DB, and returns values transitively.
/// I.e. hit the change-DB first,
///  and hit the base-DB if the change-DB does not return anything.
class DeltaDB extends MetaDataDB {

  MetaDataDB change;
  MetaDataDB base;

  @override
  Stream<MetaDataKey> get keys => StreamGroup.merge([change.keys, base.keys]);

  DeltaDB(this.change, this.base);

  @override
  Future<Uint8List> getData(MetaDataKey key) async =>
      ((await change.getData(key))
      ?? (await base.getData(key)));

  @override
  Future putData(MetaDataKey key, Uint8List value) =>
      change.putData(key, value);


}