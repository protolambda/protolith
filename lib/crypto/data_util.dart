import 'dart:typed_data';

Uint8List uint8View(ByteData data, {skip: 0, length: null})
  => new Uint8List.view(data.buffer,
      data.offsetInBytes + skip, length ?? data.lengthInBytes);

ByteData byteView(Uint8List data, {skip: 0, length: null})
  => new ByteData.view(data.buffer,
      data.offsetInBytes + skip, length ?? data.lengthInBytes);
