import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:protolith/blockchain/address.dart';
import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/encodings/rlp/rlp_decode.dart' as RlpDec;
import 'package:test/test.dart';

import 'json_util.dart';

void main() {
  Directory testsDir = new Directory('tests/fixtures/BlockchainTests');
  testsDir.listSync().forEach((ent) {
    if (ent.statSync().type != FileSystemEntityType.directory) return;
    Directory sub = Directory.fromUri(ent.uri);
    group(sub.uri.path, () {
      sub.listSync().forEach((f) {
        if (f.statSync().type != FileSystemEntityType.file) return;
        File testCase = File.fromUri(f.uri);
        Map caseSpec = jsonDecode(testCase.readAsStringSync());
        caseSpec.forEach((k, v) {
          // skip invalid cases/comments.
          if (v is! Map) return;

          test(k, () {
            CaseJSON decodedCase = CaseJSON.fromJSON(k, v);
            // TODO create chain
            // TODO apply genesis header
            // TODO apply pre state
            // TODO add blocks from test case
            // TODO validate post state
            // TODO validate resulting longest chain
            //   using original imported block data.
          });

        });
      });
    });
  });
}

class CaseJSON {
  String caseName;

  List<BlockJSON> blocks;
  BlockHeaderJSON genesisBlockHeader;
  Map<EthereumAddress, AccountJSON> pre;
  Map<EthereumAddress, AccountJSON> post;
  Hash256 lastBlockHash;
  String network;
  String sealEngine;

  CaseJSON.fromJSON(this.caseName, Map<String, dynamic> v) {
    List<dynamic> blocksData = v["blocks"];
    blocks = blocksData.map((b) => BlockJSON.fromJSON(b)).toList();
    genesisBlockHeader = BlockHeaderJSON.fromJSON(v["genesisBlockHeader"]);
    pre = parseState(v["pre"]);
    post = parseState(v["postState"]);
    lastBlockHash = decodeJSONHash256(v["lastblockhash"]);
    network = v["network"];
    sealEngine = v["sealEngine"];
  }
}

class BlockJSON {
  BlockHeaderJSON header;
  String rlp;
  List<BlockHeaderJSON> uncleHeaders;
  List<dynamic> transactions;

  BlockJSON.fromJSON(Map<String, dynamic> v) {
    if (v["blockHeader"] != null) header = BlockHeaderJSON.fromJSON(v["blockHeader"]);
    rlp = v["rlp"];
    if (v["uncleHeaders"] != null) {
      List<dynamic> uncles = v["uncleHeaders"];
      uncleHeaders = uncles.map((u) => new BlockHeaderJSON.fromJSON(u)).toList();
    }
    if (v["transactions"] != null) transactions = v["transactions"];
  }
}

class BlockHeaderJSON {
  Uint8List bloom;
  EthereumAddress coinbase;
  Hash256 mixHash;
  BigInt nonce;
  BigInt number;
  Hash256 hash;
  Hash256 parentHash;
  Hash256 receiptTrie;
  Hash256 stateRoot;
  Hash256 transactionsTrie;
  Hash256 uncleHash;
  Uint8List extraData;
  BigInt difficulty;
  int gasLimit;
  int gasUsed;
  int timestamp;


  BlockHeaderJSON.fromJSON(Map<String, dynamic> v) {
    bloom = decodeJSONUint8List(v["bloom"]);
    coinbase = decodeJSONAddress(v["coinbase"]);
    mixHash = decodeJSONHash256(v["mixHash"]);
    nonce = decodeJSONBigInt(v["nonce"]);
    number = decodeJSONBigInt(v["number"]);
    hash = decodeJSONHash256(v["hash"]);
    parentHash = decodeJSONHash256(v["parentHash"]);
    receiptTrie = decodeJSONHash256(v["receiptTrie"]);
    stateRoot = decodeJSONHash256(v["stateRoot"]);
    transactionsTrie = decodeJSONHash256(v["transactionsTrie"]);
    uncleHash = decodeJSONHash256(v["uncleHash"]);
    extraData = decodeJSONUint8List(v["extraData"]);
    gasLimit = decodeJSONInt(v["gasLimit"]);
    gasUsed = decodeJSONInt(v["gasUsed"]);
    timestamp = decodeJSONInt(v["timestamp"]);
  }
}

class AccountJSON {
  BigInt balance;
  Uint8List code;
  int nonce;
  Map storage;

  AccountJSON.fromJSON(Map<String, dynamic> v) {
    balance = decodeJSONBigInt(v["balance"]);
    code = decodeJSONUint8List(v["code"]);
    nonce = decodeJSONInt(v["nonce"]);
    storage = v["storage"];
  }
}


Map<EthereumAddress, AccountJSON> parseState(Map<String, dynamic> stateJSON) {
  Map res = new Map<EthereumAddress, AccountJSON>();
  stateJSON.forEach((k, v) {
    EthereumAddress addr = decodeJSONAddress(k);
    res[addr] = AccountJSON.fromJSON(v);
  });
  return res;
}
