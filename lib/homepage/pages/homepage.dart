import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

import 'package:nepal_blood_nexus/homepage/screens/blood_request.dart';
import 'package:nepal_blood_nexus/homepage/screens/donationplaces_screen.dart';
import 'package:nepal_blood_nexus/homepage/screens/profile.dart';
import 'package:nepal_blood_nexus/repository/user_repo.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:animated_icon/animated_icon.dart';

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
      String? userString = await storage.read(key: 'user');

      setState(() {
        token = storedToken!;
        user = User.fromJson(jsonDecode(userString!));
        loading = false;
      });

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
            // print(response["user"]);
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

  Future<void> connect() async {
    try {
      PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
      await pusher.init(
        apiKey: "b6fc6c0bbaa88e19ba69",
        cluster: "ap2",
        onError: onError,
        onEvent: onEvent,
        onSubscriptionCount: onSubscriptionCount,
        // authEndpoint: "<Your Authendpoint Url>",
        // onAuthorizer: onAuthorizer
      );
      await pusher.subscribe(channelName: "main");
      await pusher.connect();
    } catch (e) {
      debugPrint("ERROR: $e");
    }
  }

  void onError(String message, int? code, dynamic e) {
    debugPrint("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    debugPrint("onEvent: $event");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    debugPrint(
        "onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }

  @override
  void initState() {
    super.initState();
    _fetchToken().then((value) {});
    connect();
  }

  @override
  Widget build(BuildContext context) {
    late List<Widget> widgetOptions = <Widget>[
      Container(
        padding: const EdgeInsets.all(8),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Blood Pressure",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    Text(
                      "90/120 mmHg",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 11.5),
                    ),
                    Row(
                      children: [
                        Text(
                          "normal",
                          style: TextStyle(
                            color: Color.fromARGB(255, 52, 222, 10),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 52, 222, 10),
                          size: 11,
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "RBC Count",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    Text(
                      "90/120 mmHg",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 11.5),
                    ),
                    Row(
                      children: [
                        Text(
                          "Low",
                          style: TextStyle(
                            color: Color.fromARGB(255, 215, 222, 10),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.warning,
                          color: Color.fromARGB(255, 215, 222, 10),
                          size: 11,
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "WBC Count",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    Text(
                      "90/120 mmHg",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 11.5),
                    ),
                    Row(
                      children: [
                        Text(
                          "High",
                          style: TextStyle(
                            color: Colours.mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.error_outlined,
                          color: Colours.mainColor,
                          size: 11,
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Blood Pressure",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    Text(
                      "90/120 mmHg",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 11.5),
                    ),
                    Row(
                      children: [
                        Text(
                          "normal",
                          style: TextStyle(
                            color: Color.fromARGB(255, 52, 222, 10),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 52, 222, 10),
                          size: 11,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Blood Pressure",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    Text(
                      "90/120 mmHg",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 11.5),
                    ),
                    Row(
                      children: [
                        Text(
                          "normal",
                          style: TextStyle(
                            color: Color.fromARGB(255, 52, 222, 10),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 52, 222, 10),
                          size: 11,
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Blood Pressure",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    Text(
                      "90/120 mmHg",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 11.5),
                    ),
                    Row(
                      children: [
                        Text(
                          "normal",
                          style: TextStyle(
                            color: Color.fromARGB(255, 52, 222, 10),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 52, 222, 10),
                          size: 11,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            Text("data"),
          ],
        ),
      ),
      const Text(
        'Notifications',
        style: optionStyle,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileScreen(
            loading: loading,
            user: user,
            currentLocation: locationGeo,
          ),
          Container(
            color: const Color.fromARGB(95, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Blood Request",
                            style: TextStyle(
                              color: Colours.mainColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          AnimateIcon(
                            onTap: () {},
                            iconType: IconType.continueAnimation,
                            height: 16,
                            width: 16,
                            color: Colours.mainColor,
                            animateIcon: AnimateIcons.loading5,
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _onItemTapped(3);
                        },
                        child: const Row(
                          children: [
                            Text(
                              "view all",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Skeletonizer(
                    enabled: loading,
                    child: user.id != null
                        ? BloodRequestScreen(
                            token: token,
                            itemCount: 5,
                            userid: user.id as String,
                          )
                        : const Row(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Your Blood Insights",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        AnimateIcon(
                          onTap: () {},
                          iconType: IconType.continueAnimation,
                          height: 16,
                          width: 16,
                          color: Colours.mainColor,
                          animateIcon: AnimateIcons.info,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _onItemTapped(0);
                      },
                      child: const Row(
                        children: [
                          Text(
                            "More",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Icon(Icons.chevron_right)
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimateIcon(
                        onTap: () {},
                        iconType: IconType.continueAnimation,
                        height: 56,
                        width: 56,
                        color: Colours.mainColor,
                        animateIcon: AnimateIcons.hourglass,
                      ),
                      Text(
                        "Preparing Insights. Compiled blood report insights will be shown once we complete analyzing your blood report",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: user.id != null
            ? Column(
                children: [
                  BloodRequestScreen(
                    token: token,
                    itemCount: 100,
                    screen: "main",
                    userid: user.id!,
                  ),
                ],
              )
            : const Row(),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: DonationPlaces(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colours.white,
      drawerScrimColor: Colors.transparent,
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        color: Colours.mainColor,
        backgroundColor: Colors.transparent.withOpacity(0),
        animationDuration: const Duration(milliseconds: 300),
        height: 50,
        items: const <Widget>[
          Icon(Icons.insights, color: Colours.white),
          Icon(Icons.notifications, color: Colours.white),
          Icon(Icons.home_filled, color: Colours.white),
          Icon(Icons.health_and_safety_rounded, color: Colours.white),
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Good Morning"),
                        Text(
                          "${user.fullname}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colours.mainColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.allchats);
                          },
                          icon: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 30,
                          ),
                          tooltip: "More",
                          color: const Color.fromARGB(255, 242, 22, 22),
                        ),
                        IconButton(
                          onPressed: () {
                            // storage.delete(key: "token");
                            // storage.delete(key: "user");
                            Navigator.pushNamed(context, Routes.more);
                          },
                          icon: const Icon(
                            Icons.person_4_outlined,
                            size: 30,
                          ),
                          tooltip: "More",
                          color: const Color.fromARGB(255, 242, 22, 22),
                        ),
                      ],
                    ),

                    // Text("locationGeo"),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                        : const Text(
                            "Locating....",
                            style: TextStyle(fontSize: 10),
                          ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              widgetOptions[_selectedIndex]
            ],
          ),
        ),
      ),
    );
  }
}
