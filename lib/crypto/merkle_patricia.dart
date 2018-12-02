
import 'dart:collection';
import 'dart:typed_data';

import 'package:protolith/blockchain/hash.dart';
import 'package:protolith/crypto/data_util.dart';
import 'package:protolith/crypto/sha3.dart';
import 'package:protolith/encodings/rlp/rlp_encode.dart';


const int MAX_KEY_DEPTH = 64;

class Trie {

  Node root;

  Hash256 _hash;

  Hash256 get hash {
    return _hash ?? (_hash = root?.hash);
  }

  void insert(Value v) {
    root = (root == null) ? Leaf(0, v) : root.insert(v);
  }

}

abstract class Value {

  Uint8List get data;
  Uint8List get key;

  int get nibbleLength => key.lengthInBytes << 1;

  /**
   * Returns the nibble key at the given [keyDepth] in the complete value key,
   * or throws a [RangeError] if [keyDepth] is out of bounds.
   */
  int operator [](int keyDepth) => (key[keyDepth >> 1] >> (keyDepth & 1 == 1 ? 0 : 4)) & 0xf;

}

abstract class Node {

  final int keyDepth;

  /// Cached hash value,
  /// this should be reset to null to force re-computation after a change in this branch.
  Hash256 _hash;

  Hash256 get hash => _hash ?? (_hash = computeHash());

  Node(this.keyDepth);

  Hash256 computeHash();

  /// Insert value into the tree. Return this instance itself or a new instance in case the type needs to change (e.g. splitting an extension).
  Node insert(Value v);

}

class Branch extends Node with IterableMixin<Node> {

  List<Node> _nodes = new List(16);

  @override
  Iterator<Node> get iterator => _nodes.iterator;

  Value _v;

  Value get v => _v;

  set v (Value vIn) {
    _v = vIn;
    _hash = null;
  }

  Branch(int keyDepth) : super(keyDepth);

  /**
   * Returns the object at the given [key] in the branch
   * or throws a [RangeError] if [key] is out of bounds.
   */
  Node operator [](int key) => _nodes[key];

  /**
   * Sets the value at the given [key] in the branch to [value]
   * or throws a [RangeError] if [key] is out of bounds.
   *
   * Also invalidates the old hash for you.
   */
  void operator []=(int key, Node n) {
    _nodes[key] = n;
    _hash = null;
  }

  @override
  Hash256 computeHash() {
    _hash = sha3_256(byteView(encodeRLP(_nodes.map((n) => n == null ? null : n.hash.uint8list).toList()..add(v?.key ?? new Uint8List(32)))));
    return _hash;
  }

  @override
  Node insert(Value vIn) {
    if (v.nibbleLength == keyDepth) {
      this.v = vIn;
      return this;
    }

    // get the nibble corresponding to the depth of this level
    int key = vIn[keyDepth];

    Node current = _nodes[key];

    this[key] = (current == null ? new Leaf(this.keyDepth + 1, vIn) : current.insert(vIn));

    return this;
  }

  void deleteNode(int key) {
    _nodes[key] = null;
    _hash = null;
  }

}

class Extension extends Node {

  Uint8List _path;

  /// Returns a list of nibble keys, each occupying one byte for quick index based access.
  List<int> get path => new UnmodifiableListView<int>(_path);

  Node _inner;

  Node get inner => _inner;

  set inner(Node n) {
    _inner = n;
    _hash = null;
    if (keyDepth + path.length != inner.keyDepth) throw new Exception("Path cannot connect extension node with referenced node, invalid length.");
  }

  Extension(int keyDepth, this._path, this._inner) : super(keyDepth);

  @override
  Hash256 computeHash() {
    // TODO encode path
    return sha3_256(byteView(encodeRLP([_path, inner.hash])));
  }

  @override
  Node insert(Value vIn) {
    int commonKeysLen = 0;
    for (int i = 0; i < path.length && (keyDepth + i < vIn.nibbleLength); i++) {
      if (this.path[i] != vIn[keyDepth + i]) break;
      commonKeysLen++;
    }

    if (commonKeysLen == 0) {
      Branch res = Branch(this.keyDepth);
      res[this.path[0]] = this.inner;
      res.insert(vIn);
      return res;
    } else if (keyDepth + commonKeysLen == MAX_KEY_DEPTH) {
      // technically this should never happen,
      //  as this extension node should be a Leaf in this case.
      return Leaf(keyDepth, vIn);
    } else if (path.length == commonKeysLen) {
      inner = inner.insert(vIn);
      return this;
    } else {

      // Prepare the branch: we inject the inner node manually into it,
      //  based on the path it had in this extension node.
      Branch res = Branch(this.keyDepth + commonKeysLen);
      res[path[commonKeysLen]] = this.inner;
      // Also add the new value
      res.insert(vIn);
      // Now shorten this extension so that it only covers the path up to the branch.
      this._path = path.sublist(0, commonKeysLen);
      // overwrite the inner node (this also resets the hash of this node)
      this.inner = res;
      return this;
    }
  }

}

class Leaf extends Node {

  @override
  Hash256 computeHash() {
    // TODO encode path
    return sha3_256(byteView(encodeRLP([path, v.data])));
  }

  List<int> get path => new UnmodifiableListView<int>(new List.generate(v.nibbleLength, (i) => v[i]));

  final Value v;

  Leaf(int keyDepth, this.v) : super(keyDepth);

  Leaf.bottom(Value v) : this(MAX_KEY_DEPTH, v);

  @override
  Node insert(Value vIn) {
    if (this.keyDepth == MAX_KEY_DEPTH) return Leaf.bottom(vIn);
    else {
      int commonKeysLen = 0;
      for (int i = keyDepth; i < MAX_KEY_DEPTH && i < this.v.nibbleLength && i < vIn.nibbleLength; i++) {
        if (this.v[i] != vIn[i]) break;
        commonKeysLen++;
      }

      if (commonKeysLen == 0) {
        return Branch(this.keyDepth)
          ..insert(this.v)
          ..insert(v);
      } else {
        return Extension(this.keyDepth,
            new List.generate(commonKeysLen, (i) => this.v[this.keyDepth + i]),
            Branch(this.keyDepth + commonKeysLen)
              ..insert(this.v)
              ..insert(vIn)
        );
      }
    }
  }
}
