import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:streetguards/screens/home_screen.dart';
import 'package:streetguards/helpers/helpermethods.dart';
import 'package:streetguards/screens/localization_screen.dart';
import 'package:streetguards/screens/permission_screen.dart';
import 'package:streetguards/util/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streetguards/screens/profile_screen.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'Splash_Screen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool storagePermission = false;
  bool locationPermission = false;
  bool cameraPermission = false;
  bool recordPermission = false;
  bool isUserExit = false;
@override
  void dispose() {
  timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    HelperMethods().isUserExit().then((value) {
      setState(() {
        isUserExit = value;
      });
    });
    checkPermission();

    timer =  Timer.periodic(Duration(seconds: 2), (timer) {
      initialize();
    });
  }
  Timer timer;
  initialize() {
    if(isUserExit){
      if (locationPermission &&
          cameraPermission &&
          recordPermission &&
          storagePermission) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>HomeScreen()));}
      else{     Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PermissionScreen()));
      }
    }else{
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>LocalizationScreen()));
    }

    /*
    if (locationPermission &&
        cameraPermission &&
        recordPermission &&
        storagePermission) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  isUserExit ? HomeScreen() : LocalizationScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PermissionScreen()));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kButtonBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
                text: '  Street',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Guards',
                    style: TextStyle(
                        fontSize: 40,
                        color: kSecondaryColor,
                        fontWeight: FontWeight.bold),
                  )
                ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SpinKitPulse(
              color: kSecondaryColor,
              size: 50,
            ),
          )
        ],
      ),
    );
  }

  checkPermission() {
    Permission.storage.isGranted.then((value) {
      setState(() {
        storagePermission = value;
      });
    });
    Permission.location.isGranted.then((value) {
      setState(() {
        locationPermission = value;
      });
    });
    Permission.microphone.isGranted.then((value) {
      setState(() {
        recordPermission = value;
      });
    });
    Permission.camera.isGranted.then((value) {
      setState(() {
        cameraPermission = value;
      });
    });
  }
}
