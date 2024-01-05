import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/request.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';

class DonateBloodPage extends StatefulWidget {
  const DonateBloodPage({super.key, required this.bloodRequest});
  final BloodRequest bloodRequest;

  @override
  State<DonateBloodPage> createState() => _DonateBloodPageState();
}

class _DonateBloodPageState extends State<DonateBloodPage> {
  final storage = const FlutterSecureStorage();

  User local = User();

  Future<void> getCord() async {
    String? user_ = await storage.read(key: "user");

    if (user_ != "") {
      User u = User.fromJson(jsonDecode(user_!));
      setState(() {
        local = u;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Donate blood to ${widget.bloodRequest.initiator?.fullname}"),
        backgroundColor: Colours.mainColor,
        foregroundColor: Colours.white,
        actions: [
          IconButton(
            onPressed: () {
              print(widget.bloodRequest);
            },
            icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                    getLat(widget.bloodRequest.cordinates?.split(",")[0]),
                    getLat(widget.bloodRequest.cordinates?.split(",")[1])),
                maxZoom: 19,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  maxZoom: 19,
                ),
                LocationMarkerLayer(
                  position: LocationMarkerPosition(
                      latitude:
                          getLat(widget.bloodRequest.cordinates?.split(",")[0]),
                      longitude:
                          getLon(widget.bloodRequest.cordinates?.split(",")[1]),
                      accuracy: 100),
                  heading: LocationMarkerHeading(heading: 5, accuracy: 5),
                  style: LocationMarkerStyle(
                    markerDirection: MarkerDirection.top,
                    markerSize: Size.square(40),
                    accuracyCircleColor: Color.fromARGB(255, 249, 152, 162),
                    headingSectorColor: Color.fromARGB(255, 237, 131, 142),
                    marker: Container(
                      child: CircleAvatar(
                        child:
                            Text(widget.bloodRequest.initiator!.fullname![0]),
                      ),
                    ),
                  ),
                ),
                LocationMarkerLayer(
                  position: LocationMarkerPosition(
                      latitude: getLat(local.last_location?.split(",")[0]),
                      longitude: getLon(local.last_location?.split(",")[1]),
                      accuracy: 100),
                  heading: LocationMarkerHeading(heading: 5, accuracy: 5),
                  style: LocationMarkerStyle(
                    markerDirection: MarkerDirection.top,
                    markerSize: Size.square(30),
                    accuracyCircleColor: Color.fromARGB(255, 174, 249, 152),
                    headingSectorColor: Color.fromARGB(255, 27, 207, 117),
                    marker: CircleAvatar(
                      child: Text(
                          local.fullname != null ? local.fullname![0] : ""),
                    ),
                  ),
                ),
              ],
            ),
            Text("Donate Now")
          ],
        ),
      ),
    );
  }

  double getLat(String? split) {
    print(split);
    if (split != null) {
      return double.parse(split);
    } else {
      return double.minPositive;
    }
  }

  double getLon(String? split) {
    if (split != null) {
      return double.parse(split);
    } else {
      return double.minPositive;
    }
  }
}
