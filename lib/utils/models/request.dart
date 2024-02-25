import 'package:nepal_blood_nexus/utils/models/user.dart';

class BloodRequest {
  final String? id;
  final User? initiator;
  final String? status;
  final String? bloodGroup;
  final String? location;
  final String? gender;
  final String? cordinates;
  final String? udate;
  final String? cdate;

  BloodRequest({
    this.id,
    this.initiator,
    this.status,
    this.bloodGroup,
    this.location,
    this.gender,
    this.cordinates,
    this.udate,
    this.cdate,
  });

  factory BloodRequest.fromJson(Map<String, dynamic> parsedJson) {
    return BloodRequest(
      id: parsedJson['_id'].toString(),
      initiator: User.fromJson(parsedJson['initiator']),
      status: parsedJson['status'].toString(),
      bloodGroup: parsedJson['blood_group'].toString(),
      location: parsedJson['location'].toString(),
      gender: parsedJson['gender'].toString(),
      cordinates: parsedJson['cordinates'].toString(),
      cdate: parsedJson['createdAt'].toString(),
      udate: parsedJson['updatedAt'].toString(),
    );
  }
}
