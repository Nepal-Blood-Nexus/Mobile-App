import 'dart:convert';

import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/donors.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:nepal_blood_nexus/widgets/button_v1.dart';

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
      body: donors.length == 0
          ? ButtonV1(
              onTap: () {
                sendBloodRequest(true).then((value) {
                  if (value != false) {
                    List<Donors> donors_ = convertJsonToDonors(value);
                    debugPrint(donors_.toString());
                    setState(() {
                      loading = true;
                      donors = donors_;
                    });
                  }
                });
              },
              text: "Click to try Again without gender filter",
            )
          : user.phone != null
              ? FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                        double.parse(user.last_location!.split(",")[0]),
                        double.parse(user.last_location!.split(",")[1])),
                    zoom: 12,
                    minZoom: 3,
                    maxZoom: 19,
                  ),
                  children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'net.tlserver6y.flutter_map_location_marker.example',
                        maxZoom: 20,
                      ),
                      CurrentLocationLayer(
                        indicators: LocationMarkerIndicators(
                          serviceDisabled: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: double.infinity,
                              child: ColoredBox(
                                color: Colors.white.withAlpha(0x80),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    "Please turn on location service.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(height: 1.2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ...DonorPin(donors: donors),
                      SizedBox(
                        height: 200,
                        child: DonorCard(donors),
                      )
                    ])
              : Column(
                  children: [
                    AnimateIcon(
                        onTap: () {},
                        iconType: IconType.continueAnimation,
                        animateIcon: AnimateIcons.wifiSearch)
                  ],
                ),
    );
  }
}

Widget DonorCard(donors) {
  return ListView.builder(
      itemCount: donors.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
          child: ListTile(
            enabled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              donors[index].fullname.toString().toUpperCase(),
              style: const TextStyle(
                letterSpacing: 2,
                fontSize: 17,
                color: Colours.mainColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Age: ${donors[0].age}'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('Weight: ${donors[0].weight}'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${donors[index].distanceFromPreferedLocation} km away',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 18, 115, 47),
                          fontWeight: FontWeight.w600),
                    ),
                    // Text(
                    //     'Distance from User Location: ${donors[index].distanceFromuserLocation} km'),
                    const SizedBox(
                      width: 5,
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colours.mainColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.chat,
                      color: Colours.mainColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.record_voice_over_rounded,
                      color: Colours.mainColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

List<Widget> DonorPin({donors}) {
  return List.generate(
      donors.length,
      (index) => donors[index] != null
          ? LocationMarkerLayer(
              position: LocationMarkerPosition(
                  latitude:
                      double.parse(donors[index].last_location.split(",")[0]),
                  longitude:
                      double.parse(donors[index].last_location.split(",")[1]),
                  accuracy: 100),
              heading: LocationMarkerHeading(heading: 2, accuracy: 4),
              style: LocationMarkerStyle(
                // markerDirection: MarkerDirection.top,
                markerSize: const Size.square(30),
                marker: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colours.mainColor,
                  ),
                  padding: const EdgeInsets.only(top: 10),
                  width: 40,
                  child: Text(
                    getName(donors[index].fullname),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colours.white,
                        backgroundColor: Colours.mainColor),
                  ),
                ),
              ),
            )
          : const Row());
}

String getName(String name) {
  var splitted = name.split(" ");
  String _name = "${splitted[0][0]}${splitted[1][0]}";
  return _name;
}
// Skeletonizer(
//               enabled: loading,
//               // TODO: flutter maps and marker for donors
//               child: ListView.builder(
//                 itemCount: donors.length,
//                 itemBuilder: (context, index) {
//                   return DonorCard(
//                     fullname: donors[index].fullname,
//                     age: donors[index].age,
//                     weight: donors[index].weight,
//                     distanceFromPreferedLocation:
//                         donors[index].distanceFromPreferedLocation,
//                     distanceFromUserLocation:
//                         donors[index].distanceFromuserLocation,
//                     donorId: donors[index].donorId,
//                     phone: donors[index].phone,
//                   );
//                 },
//               ),
//             )