import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class BloodRequestPage extends StatefulWidget {
  const BloodRequestPage({super.key, required this.values});
  final Map<String, dynamic> values;

  @override
  State<BloodRequestPage> createState() => _BloodRequestPageState();
}

class _BloodRequestPageState extends State<BloodRequestPage> {
  bool loading = true;
  User user = User();
  String token = "";

  Future getUser() async {
    String? userString = await storage.read(key: "user");
    String? token_ = await storage.read(key: "token");
    if (userString != "" && token_ != "") {
      var parsedUser = jsonDecode(userString as String);
      setState(() {
        user = User.fromJson(parsedUser);
        token = token_!;
      });
    }
  }

//gender: Male, blood_group: AB +ve, emergency: true, location: Bhaktapur, Changunarayan, Bagmati Province, Nepal, cordinates: 27.6710221,85.4298197}
  Future sendBloodRequest() async {
    if (token != "") {
      var url = Uri.https('nbn-server.onrender.com', 'api/requests/new');
      var res = await http.post(url, body: {
        "cordinates": widget.values["cordinates"],
        "blood_group": widget.values["blood_group"],
        "location": widget.values["location"],
        "gender": widget.values["gender"],
      }, headers: {
        "authorization": "Bearer $token"
      });
      if (res.statusCode != 401) {
        var response = jsonDecode(res.body);

        return response;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((value) {
      print(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loading ? "Searching Donors" : "Found",
          style: const TextStyle(color: Colours.white),
        ),
        backgroundColor: Colours.mainColor,
        foregroundColor: Colours.white,
        actions: [
          GestureDetector(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Colours.mainColor,
                borderRadius: BorderRadius.circular(8)),
            child: const Center(
                child: Text(
              "CANCEL",
              style: TextStyle(
                  color: Colours.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            )),
          ))
        ],
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: LoadingIndicator(
                indicatorType: Indicator.circleStrokeSpin,
                strokeWidth: 7,
                colors: [Colours.mainColor],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Searching for nearby donors")
        ],
      ),
    );
  }
}
