import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepal_blood_nexus/utils/api.dart';

const storage = FlutterSecureStorage();

Future getPlaces() async {
  String? token = await storage.read(key: "token");
  if (token != "") {
    var response = await getAPI("/api/places/all");
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}
