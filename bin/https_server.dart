import "dart:io";
import "dart:isolate";
import "dart:math";

String HOST_NAME = InternetAddress.LOOPBACK_IP_V6.toString();

int myNumber = new Random().nextInt(10);

void testListenOn() {
  print('mynumber = $myNumber');
  StringBuffer data = new StringBuffer();
  HttpRequest req;
  
  HttpServer.bindSecure(HOST_NAME,
                        4049,
                        backlog: 5,
                        certificateName: 'localhost_cert').then((server) {
    ReceivePort serverPort = new ReceivePort();
    print('server: receive port');
    print(server);
    server.listen((HttpRequest request) {
      print('server: listening');
      req = request;
      request.listen(
        (buffer) {
             print('server: got request');
             data.write(new String.fromCharCodes(buffer));
        },
        onDone: () {
         print('server: on done');
          print(data);
          if (data.toString() == myNumber.toString()) {
            req.response.write('true');
          } else {
            req.response.write('false');
          }
          req.response.close();
          //request.response.close();
          serverPort.close();
          data.clear();
        });
    },
    onDone: () { print('done'); },
    onError:(e) { print('error'); });
  });
}

void InitializeSSL() {
  var testPkcertDatabase = Platform.script.resolve('pkcert').toFilePath();
  SecureSocket.initialize(database: testPkcertDatabase,
                          password: 'dartdart');
}


void main() {
  InitializeSSL();
  testListenOn();
}
