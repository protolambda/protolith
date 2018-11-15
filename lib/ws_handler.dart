import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:protolith/graph.dart';
import 'package:protolith/graph_json.dart';

void wsHandler(WebSocket webSocket) {
  // Get the graph we are working with.
  Graph zoneGraph = Zone.current[#graph];

  int clientTick = -1;
  bool clientSubscribed = false;

  void sendSince(int sinceTick) {
    List<Node> nodes = zoneGraph.getNodesSince(sinceTick);
    List<Edge> edges = zoneGraph.getEdgesSince(sinceTick);
    Map res = {
      "tickStart": sinceTick,
      "tickEnd": zoneGraph.tick,
      "nodes": nodes.map(encodeNode).toList(),
      "edges": edges.map(encodeEdge).toList()
    };
    String jsonRes = jsonEncode(res);
    webSocket.add(jsonRes);
  }

  zoneGraph.updates.listen((_) {
    if (clientSubscribed) sendSince(clientTick);
  });

  webSocket.listen((message) {
    if (message is String) {
      Map<String, dynamic> data;
      try {
        data = jsonDecode(message);
      } catch (err) {
        print("Could not decode message from client: $message");
      }
      switch (data["type"]) {
        case "subscribe":
          clientSubscribed = true;
          break;
        case "unsubscribe":
          clientSubscribed = false;
          break;
        case "confirm-tick":
          int ct = data["tick"];
          if (ct != null) clientTick = ct;
          break;
        case "get-all":
          sendSince(-1);
          break;
        case "get-since":
          int since = data["tick"];
          if (since != null) sendSince(since);
          break;
      }
    }
    print("Received msg: $message");
  });
}
