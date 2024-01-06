import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/request.dart';
import 'package:http/http.dart' as http;
import 'package:nepal_blood_nexus/utils/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen(
      {super.key, required this.token, required this.itemCount, this.screen});
  final String token;
  final int itemCount;
  final String? screen;

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

const storage = FlutterSecureStorage();

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  List<BloodRequest> bloodRequest =
      List.filled(5, BloodRequest(), growable: true);
  bool loading = true;
  String cords = "";

  List<BloodRequest> convertJsonToList(List<dynamic> jsonList) {
    return jsonList.map((json) => BloodRequest.fromJson(json)).toList();
  }

  Future<void> _getBloodRequest() async {
    var url = Uri.https('nbn-server.onrender.com', 'api/request/get');
    var res = await http
        .get(url, headers: {"authorization": "Bearer ${widget.token}"});
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      List<BloodRequest> blood_requests = convertJsonToList(response);

      debugPrint("get blood request in home screen");
      debugPrint("get user cordinates in home screen");

      setState(() {
        loading = false;
        bloodRequest = blood_requests;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getBloodRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              ButtonBar(
                children: [
                  GestureDetector(
                    child: Text("All"),
                  ),
                  GestureDetector(
                    child: Text("My Requests"),
                  ),
                ],
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
                bloodRequest.length,
                (index) => index < widget.itemCount
                    ? DonorCard(
                        context: context,
                        fullname: bloodRequest[index].initiator?.fullname,
                        bloodgroup: bloodRequest[index].bloodGroup,
                        location: bloodRequest[index].location,
                        time: getDiff(bloodRequest[index].cdate),
                        loading: loading,
                        request: bloodRequest[index],
                        cords: cords,
                      )
                    : const Row()).toList(),
          ),
        ],
      ),
    );
  }
}

String getDiff(date) {
  var _res = "";
  if (date != null) {
    DateTime dt1 = DateTime.parse(DateTime.now().toIso8601String());
    DateTime dt2 = DateTime.parse(date);

    Duration diff = dt1.difference(dt2);

    double hours = diff.inHours.toDouble();
    double minutes = diff.inMinutes.toDouble();
    double days = diff.inDays.toDouble();

    if (minutes > 0) {
      if (minutes > 60) {
        minutes = minutes % 60;
        hours = hours + (minutes / 60);
        _res += "${minutes.toInt().toString()} minutes ";
      }
    }
    if (hours > 0) {
      if (hours > 24) {
        hours = (hours % 24);
        days = days + (hours / 24);
        _res += "${hours.toInt().toString()} hours ";
      }
    }
    if (days > 0) {
      _res += "${days.toInt().toString()} days ";
    }
  }
  return _res;
}

Widget DonorCard(
    {fullname, bloodgroup, location, time, loading, context, request, cords}) {
  return Skeletonizer(
      enabled: loading,
      child: Card(
        elevation: 0,
        color: loading ? Colours.white : Color.fromARGB(255, 236, 236, 237),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          enabled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(
              //   height: 50,
              //   child: CircleAvatar(
              //     child: Text(
              //       fullname.toString()[0],
              //       style: const TextStyle(fontSize: 20),
              //     ),
              //   ),
              // ),
              Text(
                fullname.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colours.mainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  color: Colours.mainColor,
                ),
                child: Text(
                  bloodgroup.toString().split("ve")[0],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colours.white,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 2.0),
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      text: "$location",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.more_time_sharp,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 2.0),
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      text: "$time",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.donateblood,
                      arguments: request);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colours.mainColor,
                  ),
                  width: 400,
                  child: const Text(
                    "Donate Now",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colours.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ));
}
