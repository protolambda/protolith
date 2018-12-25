
import 'dart:async';
import 'dart:typed_data';

abstract class MetaDataDB {

  Future putData(MetaDataKey key, Uint8List value);
  Future<Uint8List> getData(MetaDataKey key);

}

class MetaDataKey {

  String kind;
  List<Uint8List> path;

  MetaDataKey(this.kind, this.path);

}
