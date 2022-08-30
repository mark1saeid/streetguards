import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/palette.dart';

class HelperMethods {
  Future<bool> isUserExit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isUserExit = await prefs.getString("id") == null ? false : true;
    return isUserExit;
  }

  Future<String> getImage(source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile image = await _picker.pickImage(source: source);

    if (image != null) {
      String path = image.path;
      return path;
    }
    return "";
  }

  void launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  showAlert(BuildContext context, String text) {
    AlertDialog alert;
    Widget continueButton = TextButton(
      child: Text(
        "OK",
        style: TextStyle(color: kPrimaryColor),
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    alert = AlertDialog(
      title: const Text("Alert !"),
      content: Text(text),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> getAddress(LatLng locate) async {
    print('Address');
    // LatLng locat = LatLng(currentLocation.latitude, currentLocation.longitude);
    //   print(locat);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(locate.latitude, locate.longitude);
    print(placemarks);
    for (var place in placemarks) {
      final name = place.name == null ? '' : place.name + ',';
      final subLocality =
          place.subLocality == null ? '' : place.subLocality + ',';
      final localityName = place.locality == null ? '' : place.locality + ',';
      final postalCode = place.postalCode == null ? '' : place.postalCode + ',';
      final String address =
          "$name $subLocality $localityName $postalCode ${locate.latitude},${locate.longitude}";
      print(address);
      return address;
    }
  }
}
