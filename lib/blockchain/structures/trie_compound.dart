import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/crypto/merkle_patricia.dart' as MP;


class TrieCompound<V extends MP.TrieValue> {

  List<V> _values;

  @override
  List<V> get values => new List.unmodifiable(_values);

  MP.Trie<V> _trie;

  Hash256 untrustedHash;

  Hash256 get root => _trie == null ? untrustedHash : _trie.hash;

  bool get trusted => _trie != null;

  TrieCompound(this._values, {this.untrustedHash});

  void composeTree() {
    _trie = new MP.Trie<V>();
    _values.forEach(_trie.insert);
  }
}
