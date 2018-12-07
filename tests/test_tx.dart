import 'dart:io';
import 'dart:convert';
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
          test(k, () {
            StandardTransaction tx = StandardTransaction();
          });
        });
      });
    });
}
