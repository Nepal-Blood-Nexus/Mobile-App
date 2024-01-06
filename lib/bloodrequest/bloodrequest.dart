import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/donors.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:nepal_blood_nexus/widgets/button_v1.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  bool noDonors = false;
  late List<Donors> donors = [];

  Future getUser() async {
    String? userString = await storage.read(key: "user");
    String? token_ = await storage.read(key: "token");
    if (userString != null && token_ != null) {
      var parsedUser = jsonDecode(userString);
      setState(() {
        user = User.fromJson(parsedUser);
        token = token_;
      });
    }
  }

//gender: Male, blood_group: AB +ve, emergency: true, location: Bhaktapur, Changunarayan, Bagmati Province, Nepal, cordinates: 27.6710221,85.4298197}
  Future sendBloodRequest(gender) async {
    debugPrint("sending blood request");
    debugPrint(token);
    setState(() {
      loading = true;
    });
    if (token != "") {
      var url = Uri.https('nbn-server.onrender.com', 'api/request/new',
          {"step": gender == true ? "2" : "0"});
      var res = await http.post(url, body: {
        "cordinates": widget.values["cordinates"],
        "blood_group": widget.values["blood_group"],
        "location": widget.values["location"],
        "gender": widget.values["gender"],
        "emergency": widget.values["emergency"].toString()
      }, headers: {
        "authorization": "Bearer $token"
      });
      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        debugPrint(response.toString());
        return response["donors"];
      } else {
        setState(() {
          noDonors = true;
          loading = false;
        });
        return false;
      }
    }
  }

  List<Donors> convertJsonToDonors(List<dynamic> jsonList) {
    return jsonList.map((json) => Donors.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();

    getUser().then((value) {
      sendBloodRequest(false).then((value) {
        if (value != false) {
          List<Donors> donors_ = convertJsonToDonors(value);
          setState(() {
            loading = false;
            donors = donors_;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loading
              ? "Searching Donors"
              : "${noDonors ? 0 : donors.length} Donors Found ",
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
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(
                        color: Colours.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  )),
            ),
          )
        ],
      ),
      body: noDonors
          ? ButtonV1(
              onTap: () {
                sendBloodRequest(true).then((value) {
                  if (value != false) {
                    List<Donors> donors_ = convertJsonToDonors(value);
                    debugPrint(donors_.toString());
                    setState(() {
                      loading = false;
                      donors = donors_;
                    });
                  }
                });
              },
              text: "Click to try Again without gender filter",
            )
          : Skeletonizer(
              enabled: loading,
              child: ListView.builder(
                itemCount: donors.length,
                itemBuilder: (context, index) {
                  return DonorCard(
                    fullname: donors[index].fullname,
                    age: donors[index].age,
                    weight: donors[index].weight,
                    distanceFromPreferedLocation:
                        donors[index].distanceFromPreferedLocation,
                    distanceFromUserLocation:
                        donors[index].distanceFromuserLocation,
                    donorId: donors[index].donorId,
                    phone: donors[index].phone,
                  );
                },
              ),
            ),
    );
  }
}

Widget DonorCard({
  fullname,
  age,
  weight,
  distanceFromPreferedLocation,
  distanceFromUserLocation,
  donorId,
  phone,
}) {
  return Card(
    elevation: 3.0,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ListTile(
      enabled: true,
      contentPadding: const EdgeInsets.all(18.0),
      title: Text(
        fullname.toString().toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          letterSpacing: 2,
          fontSize: 20,
          color: Colours.mainColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Age: $age'),
          Text('Weight: $weight'),
          Text(
              'Distance from Preferred Location: $distanceFromPreferedLocation km'),
          Text('Distance from User Location: $distanceFromUserLocation km'),
          Text('Donor ID: $donorId'),
          Text('Phone: $phone'),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.messenger_outline,
                color: Colours.mainColor,
              ),
              const SizedBox(
                width: 20,
              ),
              const Icon(
                Icons.phone_forwarded_outlined,
                color: Colours.mainColor,
              ),
              const SizedBox(
                width: 50,
              ),
              MaterialButton(
                color: Colours.mainColor,
                textColor: Colours.white,
                onPressed: () {},
                child: const Text("Request"),
              )
            ],
          )
        ],
      ),
    ),
  );
}
