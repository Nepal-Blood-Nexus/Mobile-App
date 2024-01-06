import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
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

  @override
  void initState() {
    // TODO: implement initState
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
            maxZoom: 14,
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
              markerSize: Size.square(30),
              accuracyCircleColor: Color.fromARGB(255, 249, 152, 162),
              headingSectorColor: Color.fromARGB(255, 237, 131, 142),
              marker: Container(
                child: CircleAvatar(
                  child: Text(widget.bloodRequest.initiator!.fullname![0]),
                ),
              ),
            ),
          ),
          Container(
            color: Colours.white,
            height: 60,
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${widget.bloodRequest.initiator!.fullname}"),
                    Text(
                        "Blood Group: ${widget.bloodRequest.bloodGroup} ${distance}KM Away")
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
