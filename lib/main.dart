import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepal_blood_nexus/homepage/pages/homepage.dart';
import 'package:nepal_blood_nexus/onboard/pages/onboard.dart';
import 'package:nepal_blood_nexus/repository/user_repo.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyALNkDBRIvBYeOse10eXW-scLwJL6UfJMA",
        appId: "1:757885051557:android:002463bb1bb3436b34a34c",
        messagingSenderId: "757885051557",
        projectId: "nepal-blood-nexus"),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String token = '';
  User user = User();
  String fcmToken = '';

  @override
  void initState() {
    super.initState();
    _fetchToken();
    FirebaseMessaging.instance.getToken().then((value) => {
          print("FCM Token Is: "),
          print(value),
          setState(() {
            fcmToken = value as String;
          })
        });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // setState(() {
        //   notifTitle = message.notification!.title;
        //   notifBody = message.notification!.body;
        // });
      }
    });
  }

  void redirectToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
  }

  Future<void> _fetchToken() async {
    try {
      String? storedToken = await storage.read(key: 'token');
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (storedToken != null) {
        LocationPermission permission;

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
          saveLocation("${position.latitude},${position.longitude}", fcmToken)
              .then((response) {
            if (response != null) {
              storage.write(key: "user", value: jsonEncode(response["user"]));
              storage.write(key: "token", value: response["token"]);
              setState(() {
                token = response["token"];
                user = User.fromJson(response["user"]);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: GoogleFonts.ubuntu(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.ubuntu(
            fontSize: 20,
          ),
          bodyMedium: GoogleFonts.raleway(),
          displaySmall: GoogleFonts.raleway(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Nepal Blood Nexus',
      home: (token != "")
          ? HomePage(
              token: token,
              user: user,
            )
          : const OnboardPage(),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
