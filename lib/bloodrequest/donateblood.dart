import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/request.dart';

class DonateBloodPage extends StatelessWidget {
  const DonateBloodPage({super.key, required this.bloodRequest});
  final BloodRequest bloodRequest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
        backgroundColor: Colours.mainColor,
        foregroundColor: Colours.white,
        actions: [
          IconButton(
            onPressed: () {
              print(bloodRequest);
            },
            icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          )
        ],
      ),
    );
  }
}
