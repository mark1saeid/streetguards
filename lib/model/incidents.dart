class Incident {
  Location location;
  String date;
  String type;
  String contact;
  String issueSubType;
  String description;
  List<String> file_ids;
  CrashData crashData;
  OtherData hazardData;
  OtherData threateningData;

  Incident(
      {this.location,
      this.date,
      this.type,
      this.description,
      this.crashData,
      this.hazardData,
      this.threateningData,
      this.file_ids,
      this.issueSubType,
      this.contact});

  Incident.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    date = json['date'].toString();
    type = json['type'].toString();
    description = json['description'].toString();
    crashData = json['crash_data'] != null
        ? CrashData.fromJson(json['crash_data'])
        : null;
    hazardData = json['hazard_data'] != null
        ? OtherData.fromJson(json['hazard_data'])
        : null;
    threateningData = json['threatening_data'] != null
        ? OtherData.fromJson(json['threatening_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['date'] = this.date;
    data['contact'] = this.contact;
    data['file_ids'] = this.file_ids;
    data['type'] = this.type;
    data['description'] = this.description;
    if (this.crashData != null) {
      data['crash_data'] = this.crashData.toJson();
    }
    if (this.hazardData != null) {
      data['hazard_data'] = this.hazardData.toJson();
    }
    if (this.threateningData != null) {
      data['threatening_data'] = this.threateningData.toJson();
    }
    return data;
  }
}

class Location {
  double lat;
  double lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class CrashData {
  String type;
  String numberInvolvedVehicles;
  String numberInvolvedBikes;
  String numberInvolvedPedesterians;
  String typeOfCollision;
  String numberOfInjuries;
  String numberOfFatalities;
  bool reporterInvolved;
  String reporterType;

  CrashData(
      {this.type,
      this.numberInvolvedVehicles,
      this.numberInvolvedBikes,
      this.numberInvolvedPedesterians,
      this.typeOfCollision,
      this.numberOfInjuries,
      this.numberOfFatalities,
      this.reporterInvolved,
      this.reporterType});

  CrashData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    numberInvolvedVehicles = json['number_involved_vehicles'].toString();
    numberInvolvedBikes = json['number_involved_bikes'].toString();
    numberInvolvedPedesterians =
        json['number_involved_pedesterians'].toString();
    typeOfCollision = json['type_of_collision'];
    numberOfInjuries = json['number_of_injuries'].toString();
    numberOfFatalities = json['number_of_fatalities'].toString();
    reporterInvolved = json['reporter_involved'];
    reporterType = json['reporter_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['number_involved_vehicles'] = this.numberInvolvedVehicles;
    data['number_involved_bikes'] = this.numberInvolvedBikes;
    data['number_involved_pedesterians'] = this.numberInvolvedPedesterians;
    data['type_of_collision'] = this.typeOfCollision;
    data['number_of_injuries'] = this.numberOfInjuries;
    data['number_of_fatalities'] = this.numberOfFatalities;
    data['reporter_involved'] = this.reporterInvolved;
    data['reporter_type'] = this.reporterType;
    return data;
  }
}

class OtherData {
  String type;

  OtherData({this.type});

  OtherData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    return data;
  }
}
