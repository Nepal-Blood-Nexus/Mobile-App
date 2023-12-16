import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepal_blood_nexus/homepage/pages/homepage.dart';
import 'package:nepal_blood_nexus/onboard/pages/onboard.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();

  String token = '';
  User user = User();

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    try {
      String? storedToken = await storage.read(key: 'token');
      String? a = await storage.read(key: "user");
      if (storedToken != null) {
        setState(() {
          token = storedToken;
          user = User.fromJson(jsonDecode(a as String));
        });
      } else {
        // Handle the case when the token is not found.
      }
    } catch (e) {
      // Handle any exceptions that may occur during token retrieval.
      print('Error fetching token: $e');
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
      home: (token != "" && user.id != null)
          ? HomePage(
              token: token,
              user: user,
            )
          : const OnboardPage(),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
