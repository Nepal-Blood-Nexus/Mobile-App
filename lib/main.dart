import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepal_blood_nexus/auth/register/pages/register.dart';
import 'package:nepal_blood_nexus/homepage/pages/homepage.dart';
import 'package:nepal_blood_nexus/onboard/pages/onboard.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    try {
      String? storedToken = await storage.read(key: 'token');

      if (storedToken != null) {
        setState(() {
          token = storedToken;
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
      debugShowCheckedModeBanner: false,
      title: 'Nepal Blood Nexus',
      home: token != "" ? const HomePage() : const OnboardPage(),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
