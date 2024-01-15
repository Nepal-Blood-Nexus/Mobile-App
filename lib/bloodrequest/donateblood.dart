import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:nepal_blood_nexus/services/calls_and_messages_service.dart';
import 'package:nepal_blood_nexus/services/service_locator.dart';
import 'package:nepal_blood_nexus/utils/algo.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/request.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key, required this.bloodRequest});

  final BloodRequest bloodRequest;

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  double? distance = 0;
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  @override
  void initState() {
    super.initState();
    calculateDistance(widget.bloodRequest.cordinates!).then((value) => {
          setState(() {
            distance = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.mainColor,
        foregroundColor: Colours.white,
        title:
            Text('Donate Blood to ${widget.bloodRequest.initiator!.fullname}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: const Text(
                    'Try to disable the location service, and you will see an '
                    'indicator on the top of the map.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(
              double.parse(widget.bloodRequest.cordinates!.split(",")[0]),
              double.parse(widget.bloodRequest.cordinates!.split(",")[1])),
          zoom: 12,
          minZoom: 0,
          maxZoom: 19,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
                'net.tlserver6y.flutter_map_location_marker.example',
            maxZoom: 20,
          ),
          CurrentLocationLayer(
            indicators: LocationMarkerIndicators(
              serviceDisabled: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ColoredBox(
                    color: Colors.white.withAlpha(0x80),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Please turn on location service.",
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          LocationMarkerLayer(
            position: LocationMarkerPosition(
                latitude:
                    double.parse(widget.bloodRequest.cordinates!.split(",")[0]),
                longitude:
                    double.parse(widget.bloodRequest.cordinates!.split(",")[1]),
                accuracy: 100),
            heading: LocationMarkerHeading(heading: 5, accuracy: 5),
            style: LocationMarkerStyle(
              markerDirection: MarkerDirection.top,
              markerSize: const Size.square(30),
              accuracyCircleColor: Color.fromARGB(255, 237, 211, 214),
              headingSectorColor: Color.fromARGB(255, 222, 193, 196),
              marker: Container(
                child: CircleAvatar(
                  child: Text(widget.bloodRequest.initiator!.fullname![0]),
                ),
              ),
            ),
          ),
          Container(
            color: Colours.white,
            height: 150,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.bloodRequest.initiator!.fullname}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "${widget.bloodRequest.bloodGroup}",
                      style: const TextStyle(
                          color: Colours.mainColor,
                          fontWeight: FontWeight.w800),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.bloodRequest.status}",
                      style: TextStyle(
                          color: Colors.green.shade400,
                          fontWeight: FontWeight.w600),
                    ),
                    Text("${distance}KM Away")
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: Text("${widget.bloodRequest.location}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.displaySmall),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimateIcon(
                      onTap: () {},
                      iconType: IconType.continueAnimation,
                      height: 20,
                      width: 20,
                      color: Colours.mainColor,
                      animateIcon: AnimateIcons.activity,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colours.mainColor,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.chat_bubble,
                              color: Colours.white,
                              size: 18,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Chat",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colours.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _service.call(widget.bloodRequest.initiator!.phone!);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colours.mainColor,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colours.white,
                              size: 18,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Call",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colours.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _service.launchMap(widget.bloodRequest.location!);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colours.mainColor,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.directions,
                              color: Colours.white,
                              size: 18,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Get Direction",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colours.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
