import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

Future<http.Response> getAPI(String path) async {
  String? token = await storage.read(key: "token");
  var url = Uri.https('nbn-server.onrender.com', path);
  var res = await http.get(url, headers: {"authorization": "Bearer $token"});
  return res;
}

Future<http.Response> postAPI(String path, Object body) async {
  String? token = await storage.read(key: "token");
  var url = Uri.https('nbn-server.onrender.com', path);
  var res = await http
      .post(url, body: body, headers: {"authorization": "Bearer $token"});
  return res;
}
