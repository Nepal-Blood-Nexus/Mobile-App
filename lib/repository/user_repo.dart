import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

Future saveLocation(location, token) async {
  String? token = await storage.read(key: "token");
  if (token != "") {
    var url =
        Uri.https('nbn-server.onrender.com', 'api/auth/profile', {"step": "0"});

    var res = await http.post(url,
        body: {"cordinates": location, "notification_token": token},
        headers: {"authorization": "Bearer $token"});
    if (res.statusCode != 401) {
      var response = jsonDecode(res.body);

      return response;
    }
  }
}
