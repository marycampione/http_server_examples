// Makes a GET request to basic_file_server.dart.
// Prints the response.

import 'dart:io';
import 'dart:convert' show UTF8, JSON;

main() {
  
  Map jsonData = { 'name':     'Luke Skywalker',
                   'job':      'reluctant hero',
                   'BFF':      'Chewbacca',
                   'ship':     'Millennium Falcon',
                   'weakness': 'carbonite'
  };
  
  new HttpClient().post(InternetAddress.LOOPBACK_IP_V6.toString(), 4043, '/file.txt')
        .then((HttpClientRequest request) {
          request.headers.add(HttpHeaders.CONTENT_ENCODING, 'JSON');
          request.write(JSON.encode(jsonData));
          return request.close();
        })
        .then((HttpClientResponse response) {
          response.transform(UTF8.decoder).listen((contents) {
            print(contents);
          });
        });

}