import "dart:async";
import "dart:io";
import "dart:isolate";
import "dart:math";
import "dart:convert";

String HOST_NAME = InternetAddress.LOOPBACK_IP_V6.toString();
Random myRandomGenerator = new Random();

void testListenOn(_) {

  var aRandomNumber = myRandomGenerator.nextInt(10);
  print('my guess = $aRandomNumber');

  HttpClient client = new HttpClient();
  ReceivePort clientPort = new ReceivePort();
  client.postUrl(Uri.parse("https://$HOST_NAME:4049/"))
    .then((HttpClientRequest request) {
      print('client: request');
      request.write(aRandomNumber.toString());
      return request.close();
    })
    .then((HttpClientResponse response) {
        response.transform(UTF8.decoder).listen(
          (data) {
            print('client: got data ${data}');
            if (data == 'true') {
              print('yay');
              client.close();
              clientPort.close();
             exit(0);
            } else {
              print('boo');
            }
          },
          onDone: () {
            
            print('client: on done');
            client.close();
            clientPort.close();
            //server.close();
            //onDone();
          });
    })
    .catchError((e, trace) {
      String msg = "Unexpected error in Https client: $e";
      if (trace != null) msg += "\nStackTrace: $trace";
    });
}

void InitializeSSL() {
  var testPkcertDatabase = Platform.script.resolve('pkcert').toFilePath();
  SecureSocket.initialize(database: testPkcertDatabase,
                          password: 'dartdart');
}

void main() {
  InitializeSSL();

  Timer timer = new Timer.periodic(new Duration(seconds: 2), testListenOn);
}
