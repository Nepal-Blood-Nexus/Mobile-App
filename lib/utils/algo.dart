import 'dart:math';

double calculateDistance(String userLocation, String destination) {
  List<String> userCoords = userLocation.split(",");
  List<String> destCoords = destination.split(",");

  double userLatitude = double.parse(userCoords[0]) * (pi / 180);
  double userLongitude = double.parse(userCoords[1]) * (pi / 180);
  double destLatitude = double.parse(destCoords[0]) * (pi / 180);
  double destLongitude = double.parse(destCoords[1]) * (pi / 180);

  double dLongitude = destLongitude - userLongitude;
  double dLatitude = destLatitude - userLatitude;
  double a = pow(sin(dLatitude / 2), 2) +
      cos(userLatitude) * cos(destLatitude) * pow(sin(dLongitude / 2), 2);

  double c = 2 * asin(sqrt(a));
  // Radius of Earth in kilometers
  double earthRadius = 6371;
  // Calculate the result
  return (c * earthRadius).roundToDouble();
}

void main() {
  String userLocation = "27.738112,85.3016576";
  String destination = "28.704060,77.102493";

  double distance = calculateDistance(userLocation, destination);
  print("Distance: $distance km");
}
