import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/homepage/screens/signupform.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key, required this.user});
  final User user;

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colours.white,
        backgroundColor: Colours.mainColor,
        title: const Text("Profile Setup"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.expand_more))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Setup your profile ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    widget.user.fullname as String,
                    style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Colours.mainColor),
                  ),
                ],
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SignupForm()],
            ),
          ],
        ),
      ),
    );
  }
}
