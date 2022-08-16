import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:streetguards/services/profile_service.dart';

import '../util/api_util.dart';

Future<String> uploadFile(File file, String takenFrom) async {
  String id = await getId();
  //String type = file.path.toString().split('.').last;
  print(file.path + "hhhhhhhhhhhhhhhh");
  String downloadUrl;
  if (file != null) {
    final fileName = basename(file.path);
    final destination = '$id/files/${takenFrom ?? "record"}/$fileName';

    await FirebaseStorage.instance
        .ref()
        .child(destination)
        .putFile(file)
        .then((p0) async {
      downloadUrl = await p0.ref.getDownloadURL();
      print(downloadUrl);
    });
    return downloadUrl;
  }
}

Future<String> uploadFileApi(File file, String takenFrom) async {
  String id;
  if (file != null) {
    var request = new http.MultipartRequest("POST", Uri.parse("$appApi/files"));
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
    ));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print("Uploaded!");
      Map<String, dynamic> result = json.decode(responseData);

      print(result["id"]);
      id = result["id"];
      return id;
    } else {
      return "";
    }
  }
}
