import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nepal_blood_nexus/homepage/screens/profile.dart';
import 'package:nepal_blood_nexus/repository/user_repo.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/request.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.user, this.token});

  final User? user;
  final String? token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String fcmToken = "";
  String locationGeo = "";
  String cords = "";
  User user = User();
  String token = "";
  bool loading = false;
  List<BloodRequest> bloodRequest = [];

  List<BloodRequest> convertJsonToList(List<dynamic> jsonList) {
    return jsonList.map((json) => BloodRequest.fromJson(json)).toList();
  }

  // String placeName = "";

  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.amber);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _fetchToken() async {
    try {
      setState(() {
        loading = true;
      });
      debugPrint("fetch token in homepage");
      String? storedToken = await storage.read(key: 'token');

      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (storedToken != null && (fcmToken == "" || cords == "")) {
        LocationPermission permission;
        FirebaseMessaging.instance.getToken().then((value) => {
              setState(() {
                fcmToken = value as String;
              }),
            });
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Got a message whilst in the foreground!');
          debugPrint('Message data: ${message.data}');
          if (message.notification != null) {
            debugPrint(
                'Message also contained a notification: ${message.notification}');
          }
        });

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return Future.error('Location permissions are denied');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.best,
                forceAndroidLocationManager: true)
            .then((Position position) {
          debugPrint("saving cords");
          saveLocation("${position.latitude},${position.longitude}", fcmToken)
              .then((response) async {
            if (response != null) {
              storage.write(key: "user", value: jsonEncode(response["user"]));
              storage.write(key: "token", value: response["token"]);
              storage.write(
                  key: "fcmToken",
                  value: "${position.latitude},${position.longitude}");
              await _getPlaceName("${position.latitude},${position.longitude}");
              setState(() {
                token = response["token"];
                user = User.fromJson(response["user"]);
                cords = "${position.latitude},${position.longitude}";
              });
            }
          });
        }).catchError((e) {
          // print(e);
        });
      } else {
        // Handle the case when the token is not found.
      }
    } catch (e) {
      // Handle any exceptions that may occur during token retrieval.
      debugPrint('Error fetching token: $e');
      // storage.delete(key: "token");
      // storage.delete(key: "user");
    }
  }

  Future<void> _getPlaceName(cords) async {
    try {
      if (cords != null) {
        var cords__ = cords.toString().split(",");
        List<Placemark> placemarks = await placemarkFromCoordinates(
            double.parse(cords__[0]), double.parse(cords__[1]));
        setState(() {
          locationGeo =
              "${placemarks[0].street!}, ${placemarks[0].subLocality} ${placemarks[0].locality} ${placemarks[0].administrativeArea} ${placemarks[0].country}";
          loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getBloodRequest() async {
    var url = Uri.https('nbn-server.onrender.com', 'api/request/get');
    var res = await http.get(url, headers: {"authorization": "Bearer $token"});
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      List<BloodRequest> blood_requests = convertJsonToList(response);
      debugPrint("get blood request in home screen");
      setState(() {
        bloodRequest = blood_requests;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    user = widget.user as User;
    token = widget.token as String;
    _fetchToken().then((value) {
      _getBloodRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    late List<Widget> widgetOptions = <Widget>[
      const Text(
        'Index 1: Business',
        style: optionStyle,
      ),
      const Text(
        'Index 2: Home',
        style: optionStyle,
      ),
      ProfileScreen(
        loading: loading,
        user: user,
        currentLocation: locationGeo,
        bloodRequest: bloodRequest,
      ),
      const Text(
        'Index 4: Requests',
        style: optionStyle,
      ),
      const Text(
        'Index 4: Requests',
        style: optionStyle,
      ),
    ];
    return Scaffold(
      backgroundColor: Colours.white,
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        color: Colours.mainColor,
        backgroundColor: Colours.white,
        animationDuration: const Duration(milliseconds: 300),
        height: 50,
        items: const <Widget>[
          Icon(Icons.insights, color: Colours.white),
          Icon(Icons.notifications, color: Colours.white),
          Icon(Icons.home_filled, color: Colours.white),
          Icon(Icons.school, color: Colours.white),
          Icon(Icons.school, color: Colours.white),
        ],
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Good Morning"),
                            Skeletonizer(
                              enabled: loading,
                              child: Text(
                                "${user.fullname}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colours.mainColor),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 13,
                                  color: Colours.mainColor,
                                ),
                                Skeletonizer(
                                  enabled: loading,
                                  child: locationGeo != ''
                                      ? Text(
                                          locationGeo,
                                          style: const TextStyle(fontSize: 11),
                                        )
                                      : const Text("Fetching"),
                                ),
                              ],
                            )
                            // Text("locationGeo"),
                          ]),
                    ]),
                    IconButton(
                      onPressed: () {
                        // storage.delete(key: "token");
                        // storage.delete(key: "user");
                        Navigator.pushNamed(context, Routes.more);
                      },
                      icon: const Icon(
                        Icons.read_more,
                        size: 30,
                      ),
                      tooltip: "More",
                      color: const Color.fromARGB(255, 242, 22, 22),
                    ),
                  ],
                ),
              ),
              widgetOptions[_selectedIndex]
            ],
          ),
        ),
      ),
    );
  }
}
