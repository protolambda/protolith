import 'graph.dart';

dynamic encodeNode(Node value) {
  Map res = {
    "id": value.id,
    "position": {
      "x": value.x,
      "y": value.y
    }
  };
  if(value.parent != null) res["parent"] = value.parent;
}

dynamic encodeEdge(Edge value) {
  return {
    "id": value.id,
    "source": value.source,
    "target": value.target
  };
}
