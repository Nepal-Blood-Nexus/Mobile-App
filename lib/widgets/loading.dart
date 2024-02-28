import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   child: Lottie.asset(
            //     'assets/images/loader.json',
            //     // fit: BoxFit.contain,
            //     width: 200,
            //     height: 200,
            //     fit: BoxFit.fill,
            //   ),
            // ),
            Text(
              "Connecting To server",
              style: TextStyle(fontSize: 11, decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }
}
