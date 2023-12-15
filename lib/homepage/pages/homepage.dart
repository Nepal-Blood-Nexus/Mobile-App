import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Good Morning"),
                      Text(
                        "${widget.user?.fullname}",
                        style: const TextStyle(fontSize: 20),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: () {
                    storage.delete(key: "token");
                    storage.delete(key: "user");
                    Navigator.pushNamed(context, Routes.login);
                  },
                  icon: const Icon(
                    Icons.logout,
                  ),
                  color: const Color.fromARGB(255, 242, 22, 22),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
