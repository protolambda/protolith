import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:protolith/blockchain/tx/standard_transaction.dart';
import 'package:test/test.dart';

void main() {
  Directory testsDir = new Directory('tests/fixtures/TransactionTests');
  testsDir.listSync().forEach((ent) {
    if (ent.statSync().type != FileSystemEntityType.directory) return;
    Directory sub = Directory.fromUri(ent.uri);
    group(sub.uri.path, () {
      sub.listSync().forEach((f) {
        if (f.statSync().type != FileSystemEntityType.file) return;
        File testCase = File.fromUri(f.uri);
        Map caseSpec = jsonDecode(testCase.readAsStringSync());
        // Default to just one case per file,
        //  but still a map; support multiple keys.
        caseSpec.forEach((k, v) {
          // skip invalid cases/comments.
          if (v is! Map) return;

          StandardTransaction tx = StandardTransaction();
          // TODO: support testing all forks
          String txHash = v["Homestead"]["hash"];
          String txSender = v["Homestead"]["sender"];
          bool succeeds = txHash != null && txSender != null;
          test(k, () {
            Uint8List txRlp;
            expect(() {
              txRlp = new Uint8List.fromList(hex.decode((v["rlp"] as String).replaceFirst("0x", "")));

              // Load the rlp into a transaction instance.
              // Errors if RLP elements cannot be transformed
              tx.decodeRLP(txRlp);

            }, succeeds ? returnsNormally : throws, verbose: true);

            if (succeeds) {
              // Now encode it again
              // Errors if properties cannot be encoded.
              Uint8List encoded = tx.encodeRLP();

              // If they match: encoding/decoding were done correctly, if not;
              //  at least one of them is incorrect.
              //  The fixture name should point to the edge case.
              expect(hex.encode(txRlp), hex.encode(encoded), verbose: true);
              tx.computeHash(null);
              String out = hex.encode(tx.hash.uint8list.toList());
              // Check hash as well, if we have one.
              if (txHash != null) expect(txHash, hex.encode(tx.hash.uint8list.toList()), verbose: true);
            }
          });
        });
      });
    });
  });
}