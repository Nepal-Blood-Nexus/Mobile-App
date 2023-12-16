import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';

class MoreOptionPage extends StatelessWidget {
  MoreOptionPage({super.key});

  final storage = const FlutterSecureStorage();

  final List<Widget> _options = <Widget>[
    GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          // color: Colours.mainColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(children: [
          Icon(
            Icons.logout,
            size: 16,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Log out",
            style: TextStyle(
                color: Colours.mainColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colours.white,
        backgroundColor: Colours.mainColor,
        title: const Text("More options"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.expand_more))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              storage.delete(key: "token");
              storage.delete(key: "user");
              Navigator.pushNamed(context, Routes.login);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                // color: Colours.mainColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(children: [
                Icon(
                  Icons.logout,
                  size: 16,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Log out",
                  style: TextStyle(
                      color: Colours.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
