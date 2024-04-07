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
      return response["chat"];
    }
  } else {
    debugPrint("Error in chat");
  }
}

Future GetChats() async {
  String? token = await storage.read(key: "token");
  if (token != "") {
    var url = Uri.https('nbn-server.onrender.com', 'api/chat/getmychats');
    var res = await http.get(url, headers: {"authorization": "Bearer $token"});
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      debugPrint("get chats");
      return response["chats"];
    }
  } else {
    debugPrint("Error in chat");
  }
}

Future sendMsg(msg, chatid) async {
  String? token = await storage.read(key: "token");
  if (token != "") {
    var url = Uri.https('nbn-server.onrender.com', 'api/chat/send');
    var res = await http.post(url,
        body: {"msg": msg, "chatid": chatid},
        headers: {"authorization": "Bearer $token"});
    if (res.statusCode == 200) {
      // var response = jsonDecode(res.body);
      debugPrint(res.body.toString());
      return res.body;
    }
  } else {
    debugPrint("Error in chat");
  }
}

Future getChat(chatid) async {
  String? token = await storage.read(key: "token");
  if (token != "") {
    var url = Uri.https('nbn-server.onrender.com', 'api/chat/get/$chatid');
    var res = await http.get(url, headers: {"authorization": "Bearer $token"});
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);

      return response["chat"];
    }
  } else {
    debugPrint("Error in chat");
  }
}
