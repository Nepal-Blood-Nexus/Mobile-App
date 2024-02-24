class DonationPlace {
  final String? name;
  final String? location;
  final String? cordinates;
  final String? image;

  DonationPlace({this.name, this.location, this.cordinates, this.image});

  factory DonationPlace.fromJson(Map<String, dynamic> parsedJson) {
    return DonationPlace(
      name: parsedJson['name'].toString(),
      location: parsedJson['location'].toString(),
      cordinates: parsedJson['cordinates'].toString(),
      image: parsedJson['image'].toString(),
    );
  }
}
