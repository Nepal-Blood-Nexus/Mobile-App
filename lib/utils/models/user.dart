class User {
  final String? id;
  final String? fullname;
  final String? email;
  final String? phone;
  final List? profile;

  User({this.id, this.fullname, this.email, this.phone, this.profile});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        id: parsedJson['name'].toString(),
        fullname: parsedJson['fullname'].toString(),
        email: parsedJson['fullname'].toString(),
        phone: parsedJson['fullname'].toString(),
        profile: parsedJson['profile']);
  }
}
