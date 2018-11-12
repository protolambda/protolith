import 'dart:typed_data';

abstract class Uint8ListSerializeable {

  /// The returned [Uint8List] may be an immutable view.
  Uint8List toUint8List();

}

abstract class Uint8ListDeserializeable<T> {

  /// The input [Uint8List] may be an immutable view.
  T fromUint8List(Uint8List input);

}