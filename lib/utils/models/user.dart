class User {
  final String? id;
  final String? fullname;
  final String? email;
  final String? phone;
  final List? profile;
  final String? last_location;

  User(
      {this.last_location,
      this.id,
      this.fullname,
      this.email,
      this.phone,
      this.profile});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['_id'].toString(),
      fullname: parsedJson['fullname'].toString(),
      email: parsedJson['email'].toString(),
      phone: parsedJson['phone'].toString(),
      profile: parsedJson['profile'],
      last_location: parsedJson['last_location'].toString(),
    );
  }
}
