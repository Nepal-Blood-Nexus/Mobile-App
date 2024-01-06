import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepal_blood_nexus/homepage/pages/homepage.dart';
import 'package:nepal_blood_nexus/onboard/pages/onboard.dart';
import 'package:nepal_blood_nexus/repository/user_repo.dart';
import 'package:nepal_blood_nexus/services/service_locator.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';
import 'package:nepal_blood_nexus/widgets/loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void showNotification(id, title, body) async {
  AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    "channelId",
    "channelName",
    priority: Priority.high,
    importance: Importance.max,
  );

  DarwinNotificationDetails darwinNotificationDetails =
      const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );

  await notificationsPlugin.show(id, title, body, notificationDetails);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    // showNotification(Random(1).nextInt(6), "${message.notification?.title}",
    //     message.notification?.body);
  }
}

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  DarwinInitializationSettings darwinInitializationSettings =
      const DarwinInitializationSettings();

  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: darwinInitializationSettings,
  );

  bool? initialized =
      await notificationsPlugin.initialize(initializationSettings);
  debugPrint("notification intialized $initialized");

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyALNkDBRIvBYeOse10eXW-scLwJL6UfJMA",
      appId: "1:757885051557:android:002463bb1bb3436b34a34c",
      messagingSenderId: "757885051557",
      projectId: "nepal-blood-nexus",
    ),
  );
  setupLocator();

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
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _fetchToken();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // this need to pushed on device
      if (message.notification != null) {
        showNotification(Random(1).nextInt(6),
            "F: ${message.notification?.title}", message.notification?.title);
      }
    });
  }

  void redirectToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
  }

  Future<void> _fetchToken() async {
    try {
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

      if (storedToken != null) {
        debugPrint("token not null setting loading");
        setState(() {
          loading = true;
        });
        LocationPermission permission;
        FirebaseMessaging.instance.getToken().then((value) => {
              debugPrint("FCM Token Is: "),
              debugPrint(value),
              setState(() {
                fcmToken = value as String;
              })
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
          saveLocation("${position.latitude},${position.longitude}", fcmToken)
              .then((response) {
            if (response != null) {
              storage.write(key: "user", value: jsonEncode(response["user"]));
              storage.write(key: "token", value: response["token"]);
              setState(() {
                token = response["token"];
                user = User.fromJson(response["user"]);
                loading = false;
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
          displaySmall: GoogleFonts.raleway(fontSize: 14),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Nepal Blood Nexus',
      home: loading
          ? const Loading()
          : (token != "")
              ? HomePage(
                  token: token,
                  user: user,
                )
              : const OnboardPage(),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
