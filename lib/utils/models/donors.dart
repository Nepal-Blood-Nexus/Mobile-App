class Donors {
  final String donorId;
  final String fullname;
  final String email;
  final String phone;
  final String age;
  final String weight;
  final String distanceFromPreferedLocation;
  final String distanceFromuserLocation;

  Donors({
    required this.donorId,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.age,
    required this.weight,
    required this.distanceFromPreferedLocation,
    required this.distanceFromuserLocation,
  });

  factory Donors.fromJson(Map<String, dynamic> parsedJson) {
    return Donors(
      donorId: parsedJson['donorId'].toString(),
      fullname: parsedJson['fullname'].toString(),
      email: parsedJson['email'].toString(),
      phone: parsedJson['phone'].toString(),
      age: parsedJson['age'].toString(),
      weight: parsedJson['weight'].toString(),
      distanceFromPreferedLocation:
          parsedJson['distanceFromPreferedLocation'].toString(),
      distanceFromuserLocation:
          parsedJson['distanceFromuserLocation'].toString(),
    );
  }
}
