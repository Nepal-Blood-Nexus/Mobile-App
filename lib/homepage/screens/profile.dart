import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';
import 'package:nepal_blood_nexus/widgets/button_v1.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key, required this.user, required this.currentLocation});
  final User user;
  final String currentLocation;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _searchingWithQuery;
  bool loading = true;
  bool showHintTextInput = false;
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> formData = {
    "gender": "",
    "blood_group": "",
    "emergency": "",
    "location": widget.currentLocation,
    "cordinates": ""
  };

  // The most recent options received from the API.
  late Iterable<String> _lastOptions = <String>[];

  Future setLoadingOff() async {
    return await Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      formData["cordinates"] = widget.user.last_location;
    });
    setLoadingOff();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colours.mainColor,
            image: DecorationImage(
              alignment: Alignment.center,
              fit: BoxFit.contain,
              opacity: 0.3,
              image: AssetImage(
                "assets/images/bg_icon_1.png",
              ),
            ),
          ),
          width: 350,
          child: widget.user.profile?.isEmpty == true
              ? ButtonV1(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.profile,
                      arguments: {"user": widget.user},
                    );
                  },
                  text:
                      "Set up your profile to get insights about your blood. Click Here to setup")
              : Skeletonizer(
                  enabled: loading,
                  child: Row(
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
                                  widget.user.profile![0]["bp"],
                                  style: const TextStyle(color: Colours.white),
                                ),
                                const Text(
                                  "Blood Pressure",
                                  style: TextStyle(
                                      color: Colours.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user.profile![0]["blood_group"] ??
                                      "__",
                                  style: const TextStyle(color: Colours.white),
                                ),
                                const Text(
                                  "Blood Group",
                                  style: TextStyle(
                                      color: Colours.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user.profile![0]["rbc"] ?? "__",
                                  style: const TextStyle(color: Colours.white),
                                ),
                                const Text(
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
                                  widget.user.profile![0]["hemoglobin"] ?? "__",
                                  style: const TextStyle(color: Colours.white),
                                ),
                                const Text(
                                  "Hemoglobin",
                                  style: TextStyle(
                                      color: Colours.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.user.profile![0]["rbc"] ?? "__",
                                  style: TextStyle(color: Colours.white),
                                ),
                                const Text(
                                  "Last Donated",
                                  style: TextStyle(
                                    color: Colours.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.user.profile![0]["wbc"] ?? "__",
                                  style: TextStyle(color: Colours.white),
                                ),
                                const Text(
                                  "WBC Count",
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
        ),
        const SizedBox(
          height: 20,
        ),
        widget.user.profile?.isEmpty == false
            ? ButtonV1(
                onTap: () {
                  showModalBottomSheet<void>(
                    useSafeArea: true,
                    isDismissible: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: Container(
                          height: 500,
                          color: const Color.fromARGB(255, 242, 241, 239),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: FormBuilder(
                                key: _formKey,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FormBuilderRadioGroup(
                                      name: "gender",
                                      onChanged: (value) {
                                        print(value);
                                        setState(() {
                                          formData["gender"] = value!;
                                        });
                                      },
                                      options: const [
                                        FormBuilderChipOption(value: "Male"),
                                        FormBuilderChipOption(value: "Female"),
                                      ],
                                      decoration: const InputDecoration(
                                          labelText: 'Gender'),
                                    ),
                                    FormBuilderDropdown(
                                      name: "blood_group",
                                      onChanged: (value) {
                                        setState(() {
                                          formData["blood_group"] = value!;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelText: 'Select your blood group'),
                                      items: const [
                                        DropdownMenuItem(
                                          value: "AB +ve",
                                          child: Text("AB +ve"),
                                        ),
                                        DropdownMenuItem(
                                          value: "AB -ve",
                                          child: Text("AB -ve"),
                                        ),
                                        DropdownMenuItem(
                                          value: "A -ve",
                                          child: Text("A -ve"),
                                        ),
                                        DropdownMenuItem(
                                          value: "A +ve",
                                          child: Text("A +ve"),
                                        ),
                                        DropdownMenuItem(
                                          value: "O +ve",
                                          child: Text("O +ve"),
                                        ),
                                        DropdownMenuItem(
                                          value: "O -ve",
                                          child: Text("O -ve"),
                                        ),
                                      ],
                                    ),
                                    FormBuilderCheckbox(
                                      name: "emergency",
                                      onChanged: (value) {
                                        setState(() {
                                          formData["emergency"] = value!;
                                        });
                                      },
                                      title: const Text("Emergency mode?"),
                                    ),

                                    const Text("Your Location"),
                                    Autocomplete(
                                      optionsMaxHeight: 100,
                                      initialValue: TextEditingValue(
                                          text: widget.currentLocation),
                                      optionsBuilder: (TextEditingValue
                                          textEditingValue) async {
                                        _searchingWithQuery =
                                            textEditingValue.text;
                                        final Iterable<String> options =
                                            await _FakeAPI.search(
                                                _searchingWithQuery!);

                                        // If another search happened after this one, throw away these options.
                                        // Use the previous options intead and wait for the newer request to
                                        // finish.
                                        if (_searchingWithQuery !=
                                            textEditingValue.text) {
                                          return _lastOptions;
                                        }

                                        _lastOptions = options;
                                        return options;
                                      },
                                      onSelected: (String selection) async {
                                        setState(() {
                                          formData["location"] = selection == ''
                                              ? widget.currentLocation
                                              : selection;
                                        });
                                        if (selection != '') {
                                          var cords__ =
                                              await locationFromAddress(
                                                  selection.toString());
                                          setState(() {
                                            formData["cordinates"] =
                                                "${cords__[0].latitude},${cords__[0].longitude}";
                                          });
                                        }
                                      },
                                    ),

                                    ButtonV1(
                                        onTap: () {
                                          setState(() {
                                            formData["location"] =
                                                formData["location"] == ''
                                                    ? widget.currentLocation
                                                    : formData["location"];
                                          });
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, Routes.bloodrequest,
                                              arguments: formData);
                                        },
                                        text: "SUBMIT"),
                                    // ElevatedButton(
                                    //   child: const Text('Close BottomSheet'),
                                    //   onPressed: () => Navigator.pop(context),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                text: "Request Blood")
            : const SizedBox(
                height: 0,
              )
      ],
    );
  }
}

const Duration fakeAPIDuration = Duration(seconds: 1);

class _FakeAPI {
  // static const List<String> _kOptions = <String>[
  //   'aardvark',
  //   'bobcat',
  //   'chameleon',
  // ];

  // Searches the options, but injects a fake "network" delay.
  static Future<Iterable<String>> search(String query) async {
    await Future<void>.delayed(fakeAPIDuration); // Fake 1 second delay.
    if (query == '') {
      return const Iterable<String>.empty();
    }
    // https://api.geoapify.com/v1/geocode/autocomplete?text=YOUR_TEXT&format=json&apiKey=YOUR_API_KEY

    var url = Uri.https('api.geoapify.com', 'v1/geocode/autocomplete', {
      "text": query,
      "fromat": "json",
      "apiKey": "5623ad58e71b41aba6091347e51b709a"
    });
    var res = await http.get(url);
    Map<String, dynamic> jsonResponse = json.decode(res.body);

    List<String> placeNames = (jsonResponse['features'] as List)
        .map<String>((feature) => feature['properties']['formatted'].toString())
        .toList();
    // Print the list of place names

    return placeNames;

    // return const Iterable<String>.empty();
  }
}
