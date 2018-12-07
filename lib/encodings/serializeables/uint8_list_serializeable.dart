import 'dart:typed_data';

abstract class Uint8ListEncodeable {

  /// The returned [Uint8List] may be an immutable view.
  Uint8List toUint8List();

}


// Note: In some cases it may be undesirable to inject data into an existing instance.
// Create a `MyClass.fromUint8List(Uint8List input)` or `MyClass.fromUint8List(Uint8List input)` constructor in that case.
abstract class Uint8ListDecodeable<T> {

  /// The input [Uint8List] may be an immutable view.
  T fromUint8List(Uint8List input);

}