import 'dart:async';
import 'dart:convert';

import 'package:chainviz_server/graph.dart';
import 'package:chainviz_server/graph_json.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

void startGraphWS() async {

  // Get the graph we are working with.
  Graph zoneGraph = Zone.current[#graph];
  

  var handler = webSocketHandler((webSocket) {

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

    zoneGraph.updates.listen((_){
      if (clientSubscribed) sendSince(clientTick);
    });

    webSocket.stream.listen((message) {
      if (message is String) {
        List<String> parts = message.split(";");
        switch (parts[0]) {
          case "subscribe":
            clientSubscribed = true;
            break;
          case "unsubscribe":
            clientSubscribed = false;
            break;
          case "confirm-tick":
            int ct = int.parse(parts[1]?.trim(), onError: (s){
              print("Invalid get-since param: $s");
              return null;
            });
            if (ct != null) clientTick = ct;
            break;
          case "get-all":
            sendSince(-1);
            break;
          case "get-since":
            int since = int.parse(parts[1]?.trim(), onError: (s){
              print("Invalid get-since param: $s");
              return null;
            });
            if (since != null) sendSince(since);
            break;
        }
      }
      print("Received msg: $message");
    });
  });

  await shelf_io.serve(handler, 'localhost', 8080).then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });
}