import 'dart:io';

import 'package:args/args.dart';

import 'package:chainviz_server/ws_handler.dart';

const String notFoundPageHtml = '''
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>No resource for this URL.</p>
</body></html>''';

main(List<String> args) async {
  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8081');

  var result = parser.parse(args);

  var port = int.tryParse(result['port']);

  if (port == null) {
    stdout.writeln(
        'Could not parse port value "${result['port']}" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  HttpServer.bind(InternetAddress.loopbackIPv4, port)
      .then((HttpServer server) {

    server.listen((HttpRequest request) {
      if (request.uri.path == '/ws') {
        WebSocketTransformer.upgrade(request).then(wsHandler, onError: (err) {
          print("Failed to upgrade websocket request.");
        });
      } else {
        HttpResponse response = request.response;
        response.statusCode = HttpStatus.NOT_FOUND;
        response.headers.set('Content-Type', 'text/html; charset=UTF-8');
        response.write(notFoundPageHtml);
        response.close();
      }
    });
  });


  print('Serving at http://localhost:$port');

}

