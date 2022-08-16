import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetguards/services/profile_service.dart';
import 'package:uuid/uuid.dart';

import '../model/incidents.dart';
import '../model/report.dart';
import '../util/api_util.dart';

Future storeReportData(Report report) async {
  String id = Uuid().v1();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String date = dateFormat.format(DateTime.now());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    report.id = id;
    report.userId = prefs.getString("id");
    report.date = date;
    print("okkk");
    Response response = await Dio()
        .patch('$firebaseApi/reports/$id.json', data: report.toMap());
    if (response.statusCode == 200) {}
  } catch (e) {
    log(e.toString());
  }
}

Future<List<Report>> getReportData() async {
  try {
    Response response = await Dio().get('$firebaseApi/reports/.json');
    if (response.statusCode == 200) {
      List<Report> reports = [];

      Map<dynamic, dynamic> myMap = response.data;

      myMap.forEach((i, value) {
        reports.add(Report.fromMap(value));
      });

      return reports;
    }
  } catch (e) {
    log(e.toString());
  }
  return [];
}

Future storeIncidentsData(Incident incident) async {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String date = dateFormat.format(DateTime.now());
  String userId = await getId();

  try {
    if (incident.date == null) {
      incident.date = date;
    }
    incident.contact = userId;
    print(incident.toJson().toString());
    Response response =
        await Dio().post('$appApi/add', data: incident.toJson());
    print("response ${response.data}");
    if (response.statusCode == 200) {}
  } catch (e) {
    log(e.toString());
  }
}

Future<List<Incident>> getIncidentsData() async {
  print("test");
  try {
    Response response = await Dio().get('$appApi/all');

    if (response.statusCode == 200) {
      List<Incident> reports = [];
      response.data["data"].toList().forEach((value) {
        reports.add(Incident.fromJson(value));
      });
      return reports;
    }
  } catch (e) {
    log(e.toString());
  }
  return [];
}
