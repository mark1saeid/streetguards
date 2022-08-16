import 'package:google_maps_flutter/google_maps_flutter.dart';

class Report {
  ///common
  String id;
  String userId;
  String issueType;
  String issueSubType;
  String description;
  String location;
  String date;
  String issueDate;
  String image;
  String voice;

  ///crash
  String numberOfInvolved;
  bool reporterInvolved;
  String reporterType;
  String typeOfCollision;
  String numberOfInjuries;
  String numberOfFatalities;

  Report(
      {this.id,
      this.userId,
      this.issueType,
      this.issueSubType,
      this.description,
      this.location,
      this.date,
      this.image,
      this.voice,
      this.numberOfInvolved,
      this.reporterInvolved,
      this.reporterType,
      this.typeOfCollision,
      this.numberOfInjuries,
      this.numberOfFatalities,
      this.issueDate});

  LatLng toLatLng(String element) {
    return LatLng(double.parse(element.split(',').first),
        double.parse(element.split(',').last));
  }

  String fromLatLng(LatLng element) {
    return "${element.latitude},${element.longitude}";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userId': this.userId,
      'issueType': this.issueType,
      'issueSubType': this.issueSubType,
      'description': this.description,
      'location': this.location,
      'date': this.date,
      'image': this.image,
      'voice': this.voice,
      'issueDate': this.issueDate,
      'numberOfInvolved': this.numberOfInvolved,
      'reporterInvolved': this.reporterInvolved,
      'reporterType': this.reporterType,
      'typeOfCollision': this.typeOfCollision,
      'numberOfInjuries': this.numberOfInjuries,
      'numberOfFatalities': this.numberOfFatalities,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] as String,
      userId: map['userId'] as String,
      issueType: map['issueType'] as String,
      issueSubType: map['issueSubType'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      date: map['date'] as String,
      issueDate: map['issueDate'] as String,
      image: map['image'] as String,
      voice: map['voice'] as String,
      numberOfInvolved: map['numberOfInvolved'].toString(),
      reporterInvolved: map['reporterInvolved'] as bool,
      reporterType: map['reporterType'],
      typeOfCollision: map['typeOfCollision'],
      numberOfInjuries: map['numberOfInjuries'].toString(),
      numberOfFatalities: map['numberOfFatalities'].toString(),
    );
  }
}
