import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetguards/model/user.dart';
import 'package:uuid/uuid.dart';

import '../util/api_util.dart';

storeProfileData(User user) async {
  String id = await getId();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String date = dateFormat.format(DateTime.now());
  try {
    user.userId = id;
    user.date = date;
    Response response =
        await Dio().patch('$firebaseApi/users/$id.json', data: user.toMap());
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', id);
    }
  } catch (e) {
    log(e.toString());
  }
}

Future<User> getProfileData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString("id");
  try {
    Response response = await Dio().get('$firebaseApi/users/$id.json');
    if (response.statusCode == 200) {
      User user = User.fromMap(response.data);
      return user;
    }
  } catch (e) {
    log(e.toString());
  }
  return User();
}

Future createUserData(User user) async {
  String id = await getId();
  user.userId = id;
  try {
    Response response =
        await Dio().post('$appApi/user/create', data: user.toMap());

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', id);
    }
  } catch (e) {
    log(e.toString());
  }
}

Future<User> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString("id");
  try {
    Response response = await Dio().get('$appApi/user?userId=$id');
    if (response.statusCode == 200) {
      User user = User.fromMap(response.data);
      return user;
    }
  } catch (e) {
    log(e.toString());
  }
  return User();
}

Future<String> getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId ?? Uuid().v1(); // unique ID on Android
  }
}
