import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colours.mainColor,
            image: DecorationImage(
              image: AssetImage("assets/images/1.png"),
            ),
          ),
          width: 350,
          child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "120–160 g/L",
                          style: TextStyle(color: Colours.white),
                        ),
                        Text(
                          "Hemoglobin",
                          style: TextStyle(
                              color: Colours.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "16 Dec 2023",
                          style: TextStyle(color: Colours.white),
                        ),
                        Text(
                          "Last Donated",
                          style: TextStyle(
                              color: Colours.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "0.025–0.035 L/kg",
                          style: TextStyle(color: Colours.white),
                        ),
                        Text(
                          "RBC",
                          style: TextStyle(
                            color: Colours.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "120–160 g/L",
                          style: TextStyle(color: Colours.white),
                        ),
                        Text(
                          "Hemoglobin",
                          style: TextStyle(
                              color: Colours.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "0.025–0.035 L/kg",
                          style: TextStyle(color: Colours.white),
                        ),
                        Text(
                          "RBC",
                          style: TextStyle(
                            color: Colours.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "0.15–0.47 mmol/L",
                          style: TextStyle(color: Colours.white),
                        ),
                        Text(
                          "Uric Acid",
                          style: TextStyle(
                            color: Colours.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
        ),
      ],
    );
  }
}
