import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

Future initiateChatwithRequest(requestId) async {
  String? token = await storage.read(key: "token");
  if (token != "") {
    var url = Uri.https('nbn-server.onrender.com', 'api/chat/initialize');
    var res = await http.post(url,
        body: {"requestid": requestId},
        headers: {"authorization": "Bearer $token"});
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      debugPrint("initialize chat");
      return response["chat"][0];
    }
  } else {
    debugPrint("Error in chat");
  }
}
