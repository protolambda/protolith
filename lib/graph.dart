import 'dart:async';

class Node {

  int tick = 0;
  bool dirty = false;
  bool deleted = false;

  int _x = 0;
  int get x => _x;
  set x(int value) {
    _x = value;
    dirty = true;
  }

  int _y = 0;
  int get y => _y;
  set y(int value) {
    _y = value;
    dirty = true;
  }

  Set<String> _classes = Set();
  void addClass(String s) {
    if (_classes.add(s)) dirty = true;
  }
  void removeClass(String s) {
    if (_classes.remove(s)) dirty = true;
  }

  String _id;
  String get id => _id;

  String parent;

  Node(this._id) {
    Graph zoneGraph = Zone.current[#graph];
    zoneGraph.nodes[_id] = this;
  }

  void delete() {
    if(!deleted) {
      deleted = true;
      dirty = true;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Node &&
              runtimeType == other.runtimeType &&
              _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  @override
  String toString() {
    return 'Node{id: $_id}';
  }

}

class Edge {

  int tick = 0;
  bool dirty = false;
  bool deleted = false;

  String _target;
  String get target => _target;
  set target(String value) {
    _target = value;
    dirty = true;
  }

  String _source;
  String get source => _source;
  set source(String value) {
    _source = value;
    dirty = true;
  }

  String _id;
  String get id => _id;

  Edge(this._id) {
    Graph zoneGraph = Zone.current[#graph];
    zoneGraph.edges[_id] = this;
  }

  void delete() {
    if(!deleted) {
      deleted = true;
      dirty = true;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Edge &&
              runtimeType == other.runtimeType &&
              _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  @override
  String toString() {
    return 'Edge{id: $_id}';
  }

}

class Graph {

  Map<String, Node> nodes = Map();

  Map<String, Edge> edges = Map();

  int tick = -1;

  /**
   * Update the flags of the items in the graph;
   *  each dirty item will no longer be dirty, and have its tick value updated.
   */
  void update() {
    // New update -> increment tick value
    tick++;
    // Go over all dirty items, update their tick, and reset dirty flag.
    for (Node node in nodes.values) {
      if(node.dirty) {
        node.tick = tick;
        node.dirty = false;
      }
    }
    for (Edge edge in edges.values) {
      if(edge.dirty) {
        edge.tick = tick;
        edge.dirty = false;
      }
    }
  }

  /// Get all nodes that had a change since the given tick (inclusive).
  List<Node> getNodesSince(int sinceTick) =>
      nodes.values.where((n) => n.tick >= sinceTick);

  /// Get all edges that had a change since the given tick (inclusive).
  List<Edge> getEdgesSince(int sinceTick) =>
      edges.values.where((e) => e.tick >= sinceTick);

  // Create the update stream; this is what clients will be updated with.
  final StreamController _updateStreamController = new StreamController<void>.broadcast();

  Stream get updates => _updateStreamController.stream;

  Timer _periodicUpdateTimer;

  Graph() {
    _updateStreamController.stream.listen((_) => this.update());
  }

  void startUpdates() {
    if (_periodicUpdateTimer == null)
      _periodicUpdateTimer = new Timer.periodic(
          const Duration(seconds: 1),
              (_) => _updateStreamController.add(null));
  }

  void stopUpdates() {
    _periodicUpdateTimer?.cancel();
    _periodicUpdateTimer = null;
  }

  void close() {
    _updateStreamController.close();
  }
}

