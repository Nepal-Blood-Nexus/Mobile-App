import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepal_blood_nexus/homepage/screens/profile.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.user, this.token});

  final User? user;
  final String? token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.amber);

  static const List<Widget> _widgetOptions = <Widget>[
    ProfileScreen(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: Home',
      style: optionStyle,
    ),
    Text(
      'Index 4: Requests',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        color: Colours.mainColor,
        backgroundColor: Colours.white,
        animationDuration: const Duration(milliseconds: 300),
        height: 50,
        items: const <Widget>[
          Icon(
            Icons.face_4,
            color: Colours.white,
          ),
          Icon(Icons.insights, color: Colours.white),
          Icon(Icons.school, color: Colours.white),
          Icon(Icons.school, color: Colours.white),
          Icon(Icons.school, color: Colours.white),
        ],
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Good Morning"),
                        Text(
                          "${widget.user?.fullname}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        widget.user?.profile == null
                            ? const Text("Set up your profile")
                            : const Row(),
                      ]),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: IconButton(
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
                )
              ],
            ),
            _widgetOptions[_selectedIndex]
          ],
        ),
      ),
    );
  }
}
