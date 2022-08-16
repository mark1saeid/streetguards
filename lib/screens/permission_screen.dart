import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streetguards/screens/splash_screen.dart';

import '../util/palette.dart';

class PermissionScreen extends StatefulWidget {
  static String id = 'Permission_Screen';

  const PermissionScreen({Key key}) : super(key: key);

  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<PermissionScreen> {
  bool storagePermission = false;
  bool locationPermission = false;
  bool cameraPermission = false;
  bool recordPermission = false;

  @override
  initState() {
    super.initState();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    checkPermission();
    return Container(
      color: kBackGroundColor,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: kBackGroundColor,
          body: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        checkPermission();
                        await Permission.location
                            .request()
                            .then((value) => checkPermission())
                            .whenComplete(() => checkPermission());
                      },
                      child: ListTile(
                        title:  Text(
                          "permissionT1",
                          style: TextStyle(color: kTextColor,
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ).tr(),
                        subtitle:  Text(
                          "permissionDesc1",
                          style: TextStyle(fontSize: 16,color: kTextColor),
                        ).tr(),
                        trailing: locationPermission
                            ? Icon(
                                Icons.where_to_vote_rounded,
                                color: kSecondaryColor,
                              )
                            : const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () async {
                        checkPermission();
                        await Permission.storage
                            .request()
                            .then((value) => checkPermission())
                            .whenComplete(() => checkPermission());
                      },
                      child: ListTile(
                        title:  Text(
                          "permissionT2",
                          style: TextStyle(color: kTextColor,
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ).tr(),
                        subtitle:  Text(
                          "permissionDesc2",
                          style: TextStyle(fontSize: 16,color: kTextColor),
                        ).tr(),
                        trailing: storagePermission
                            ? Icon(
                                Icons.where_to_vote_rounded,
                                color: kSecondaryColor,
                              )
                            : const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () async {
                        checkPermission();
                        await Permission.camera
                            .request()
                            .then((value) => checkPermission())
                            .whenComplete(() => checkPermission());
                      },
                      child: ListTile(
                        title:  Text(
                          "permissionT3",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,color: kTextColor),
                        ).tr(),
                        subtitle:  Text(
                          "permissionDesc3",
                          style: TextStyle(fontSize: 16,color: kTextColor),
                        ).tr(),
                        trailing: cameraPermission
                            ? Icon(
                                Icons.where_to_vote_rounded,
                                color: kSecondaryColor,
                              )
                            : const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () async {
                        checkPermission();
                        await Permission.microphone
                            .request()
                            .then((value) => checkPermission())
                            .whenComplete(() => checkPermission());
                      },
                      child: ListTile(
                        title:  Text(
                          "permissionT4",
                          style: TextStyle(color: kTextColor,
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ).tr(),
                        subtitle:  Text(
                          "permissionDesc4",
                          style: TextStyle(fontSize: 16,color: kTextColor),
                        ).tr(),
                        trailing: recordPermission
                            ? Icon(
                                Icons.where_to_vote_rounded,
                                color: kSecondaryColor,
                              )
                            : const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kSecondaryColor),
                        ),
                        onPressed: () async {
                          if (
                              //alwaysLocationPermission &&
                              locationPermission &&
                                  cameraPermission &&
                                  recordPermission &&
                                  storagePermission) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>SplashScreen()));
                          } else {
                            showAlertDialog(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "permissionB1",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ).tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkPermission() {
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

  showAlertDialog(BuildContext context) {
    AlertDialog alert =  AlertDialog(
      backgroundColor: kBackGroundColor,
      title: Text("permissionT5",style: TextStyle(color: kTextColor),).tr(),
      content: Text("permissionDesc5",style: TextStyle(color: kTextColor),).tr(),
      actions: [
        //  continueButton,
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
}
