import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/repository/places_repo.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/places.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DonationPlaces extends StatefulWidget {
  const DonationPlaces({super.key});

  @override
  State<DonationPlaces> createState() => _DonationPlacesState();
}

class _DonationPlacesState extends State<DonationPlaces> {
  late List<DonationPlace> _donationPlaces =
      List.filled(3, DonationPlace(), growable: true);
  bool loading = true;

  List<DonationPlace> convertJsonToDonors(List<dynamic> jsonList) {
    return jsonList.map((json) => DonationPlace.fromJson(json)).toList();
  }

  void setPlaces() async {
    String places = await getPlaces();
    List<DonationPlace> donors_ = convertJsonToDonors(jsonDecode(places));
    setState(() {
      _donationPlaces = donors_;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPlaces();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Skeletonizer(
            enabled: loading,
            child: Column(children: [
              Text(
                "Nearby Donation Centers",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 10,
              ),
              ...getCards(places: _donationPlaces)
            ])),
      ),
    );
  }
}

List<Widget> getCards({places}) {
  return List.generate(
      places.length,
      (index) => places[index].name != null
          ? Card(
              elevation: 1,
              margin: EdgeInsets.only(bottom: 20),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero),
              ),
              child: Container(
                color: Color.fromARGB(31, 222, 217, 217),
                padding: EdgeInsets.all(0),
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        places[index].name,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colours.mainColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Image.network(
                      places[index].image,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                          ),
                          Text(
                            places[index].location,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : const Row());
}
