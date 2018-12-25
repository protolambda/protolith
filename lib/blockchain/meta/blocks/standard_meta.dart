import 'package:protolith/blockchain/meta/blocks/meta.dart';
import 'package:protolith/blockchain/meta/blocks/metas/ethash.dart';
import 'package:protolith/blockchain/meta/blocks/metas/code.dart';
import 'package:protolith/blockchain/meta/blocks/metas/storage.dart';
import 'package:protolith/blockchain/meta/blocks/metas/nonce.dart';
import 'package:protolith/blockchain/meta/blocks/metas/value.dart';

class StandardBlockMeta extends BlockMeta
    with
        EthashBlockMeta,
        CodeBlockMeta,
        StorageBlockMeta,
        NonceBlockMeta,
        ValueBlockMeta {


}
