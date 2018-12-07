
import 'dart:typed_data';
import 'package:protolith/encodings/rlp/rlp_encode.dart' as RlpEnc;
import 'package:protolith/encodings/rlp/rlp_decode.dart' as RlpDec;

mixin RlpEncodeable<M> {

  Uint8List encodeRLP([M m]) => RlpEnc.encodeRLP(this.getRlpElements(m));

  List<dynamic> getRlpElements([M m]);

}

typedef void RlpDecSetter(dynamic v);

mixin RlpDecodeable {

  /// Decodes the RLP input [rlp] into this instance.
  /// The instance is changed by applying the setters returned by getRlpSetters.
  void decodeRLP(Uint8List rlp) {
    List<RlpDecSetter> transforms = this.getRlpSetters();
    List<dynamic> rawDecoded = RlpDec.decodeRLP(rlp);
    if (transforms == null || transforms.length != rawDecoded.length) throw Exception("RLP input was decoded into a list not matching the RLP-transforms.");
    // apply transforms to corresponding items
    for (int i = 0; i < transforms.length; i++) {
      transforms[i](rawDecoded[i]);
    }
  }

  List<RlpDecSetter> getRlpSetters();

}