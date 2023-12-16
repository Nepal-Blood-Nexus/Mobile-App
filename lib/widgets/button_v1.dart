import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';

class ButtonV1 extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const ButtonV1({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Colours.mainColor, borderRadius: BorderRadius.circular(8)),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(
              color: Colours.white, fontSize: 16, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
