import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:map_pin_picker/map_pin_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:streetguards/model/incidents.dart';
import 'package:streetguards/screens/report_screen.dart';
import 'package:streetguards/services/profile_service.dart';
import 'package:streetguards/services/report_service.dart';
import 'package:uuid/uuid.dart';

import '../model/cluster.dart';
import '../model/incidents.dart' as incident;
import '../model/report.dart';
import '../model/user.dart';
import '../services/media_service.dart';
import '../util/api_util.dart';
import '../util/palette.dart';
import 'profile_screen.dart';

List<String> appliedFilter = [
  null,
  'crash_near_miss',
  'hazard',
  'threatening',
];
List<String> filter = [
  'crash_near_miss',
  'hazard',
  'threatening',
];
List<String> filterKeys = [
  't1',
  't2',
  't3',
];

class HomeScreen extends StatefulWidget {
  static String id = 'Home_Screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentPhoneDate = DateTime.now();
  MapPickerController mapPickerController = MapPickerController();
  CameraPosition cameraPosition =
      CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 8.0);
  String _mapStyle;
  bool locationToggle = true;
  bool isLoading = false;
  bool isLocating = false;
  bool isRecording = false;
  bool isSearching = false;
  Incident report = Incident();
  LatLng currentLocation;
  ClusterManager _manager;
  GoogleMapController _controller;
  String tempPath;

  Timer timer;
  int timerCount = 0;

  Set<Marker> markers = Set();

  List<Incident> filteredReports = [];

  List<Place> marker = [];

  getCurrentLocation() {
    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = LatLng(currloc.latitude, currloc.longitude);
        locationToggle = false;
      });
      //  moveToCurrentLocation();
    });
  }

  moveToCurrentLocation() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 15.0)));
  }

  @override
  void initState() {
    super.initState();
    _manager = _initClusterManager();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    getCurrentLocation();
    showReportData();
    searchController = TextEditingController();
    googlePlace = GooglePlace(mapApiKey);
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(marker, _updateMarkers,
        levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0],
        extraPercent: 0.2,
        markerBuilder: _markerBuilder,
        stopClusteringZoom: 17.0);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  final record = Record();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kButtonBackground,
      body: SafeArea(
        child: Stack(children: [
          /*  locationToggle
              ? SpinKitDoubleBounce(
                  color: kSecondaryColor,
                  size: 50,
                )
              :*/
          Scaffold(
            floatingActionButton: isSearching
                ? SizedBox()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isRecording
                              ? Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Colors.red.shade500,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          side: BorderSide(
                                              color: kSecondaryColor)),
                                      child: Icon(
                                        Icons.cancel_rounded,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        record.stop();
                                        setState(() {
                                          isRecording = false;
                                          tempPath = "";
                                        });
                                        if (timer != null) {
                                          timer.cancel();
                                          timerCount = 0;
                                        }
                                      },
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Color(0xFF1D1D27),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          side: BorderSide(
                                              color: kSecondaryColor)),
                                      child: Icon(
                                        Icons.filter_alt_rounded,
                                        color: kSecondaryColor,
                                      ),
                                      onPressed: () {
                                        /*showDialog(
                                            context: context,
                                            builder: (_) {
                                              return MyDialog();
                                            });*/
                                        _showMyDialogFilter();
                                      },
                                    ),
                                  ),
                                ),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: isRecording
                                  ? FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          side: BorderSide(
                                              color: kSecondaryColor)),
                                      child: Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        record.stop();
                                        _showMyDialogTypeChoose(tempPath);
                                        setState(() {
                                          tempPath = "";
                                          isRecording = false;
                                        });
                                        if (timer != null) {
                                          timer.cancel();
                                          timerCount = 0;
                                        }
                                      },
                                    )
                                  : FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Color(0xFF1D1D27),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          side: BorderSide(
                                              color: kSecondaryColor)),
                                      child: Icon(
                                        Icons.keyboard_voice_rounded,
                                        color: kSecondaryColor,
                                      ),
                                      onPressed: () async {
                                        bool result =
                                            await record.hasPermission();
                                        if (result) {
                                          setState(() {
                                            isRecording = true;
                                            getTemporaryDirectory()
                                                .then((tempDir) async {
                                              String name = Uuid().v1();
                                              tempPath =
                                                  "${tempDir.path}/$name.m4a";
                                              print(tempPath);
                                              await record.start(
                                                path: tempPath, // required
                                              );
                                            });
                                          });
                                          timer = Timer.periodic(
                                              Duration(seconds: 1), (timer) {
                                            setState(() {
                                              timerCount = timerCount + 1;
                                            });
                                          });

                                          Future.delayed(Duration(seconds: 30),
                                              () {
                                            if (tempPath != "") {
                                              record.stop();
                                              _showMyDialogTypeChoose(tempPath);
                                              setState(() {
                                                isRecording = false;
                                                tempPath = "";
                                              });
                                              if (timer != null) {
                                                timer.cancel();
                                                timerCount = 0;
                                              }
                                            }
                                          });
                                        }
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                      isRecording
                          ? SizedBox()
                          : FloatingActionButton.extended(
                              heroTag: null,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: kSecondaryColor)),
                              onPressed: () {
                                if (!isLocating) {
                                  setState(() {
                                    isLocating = true;
                                  });
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReportScreen(
                                              location: Report().fromLatLng(
                                                  cameraPosition.target))));
                                }
                              },

                              label: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  isLocating ? 'homeB1' : 'homeB2',
                                  style: TextStyle(
                                      fontSize: 20, color: kSecondaryColor),
                                ).tr(),
                              ),
                              // icon: const Icon(Icons.dangerous),
                              backgroundColor: Color(0xFF1D1D27),
                            ),
                    ],
                  ),
            bottomNavigationBar: BottomAppBar(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Container(
              child: MapPicker(
                  mapPickerController: mapPickerController,
                  iconWidget: isLocating
                      ? Icon(
                          Icons.location_pin,
                          color: kSecondaryColor,
                          size: 50,
                        )
                      : null,
                  showDot: isLocating ? true : false,
                  child: googleMap()),
            ),
          ),
          isLoading
              ? Align(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.14,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kSecondaryColor,
                        width: 1,
                      ),
                      color: kButtonBackground,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SpinKitPulse(
                            color: kSecondaryColor,
                            size: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Text(
                            "homeT9",
                            style: TextStyle(
                                color: kTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          isRecording
              ? Align(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kSecondaryColor,
                        width: 1,
                      ),
                      color: kButtonBackground,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "homeT1",
                            style: TextStyle(
                                color: kTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ).tr(args: [timerCount.toString()]),
                          SpinKitWave(
                            itemCount: 10,
                            color: kSecondaryColor,
                            size: MediaQuery.of(context).size.height * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kSecondaryColor,
                      width: 1,
                    ),
                    color: kButtonBackground,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isSearching
                            ? FloatingActionButton(
                                heroTag: null,
                                backgroundColor: kButtonBackground,
                                onPressed: () {
                                  setState(() {
                                    isSearching = false;
                                  });
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: kTextColor,
                                  size: 30,
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                    text: '  Street',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Guards',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                        Row(
                          children: [
                            FloatingActionButton(
                              heroTag: null,
                              backgroundColor: kButtonBackground,
                              onPressed: () {
                                showReportData();
                              },
                              child: Icon(
                                Icons.refresh_rounded,
                                color: kTextColor,
                                size: 30,
                              ),
                            ),
                            FloatingActionButton(
                              heroTag: null,
                              backgroundColor: kButtonBackground,
                              onPressed: () {
                                setState(() {
                                  if (isSearching) {
                                    isSearching = false;
                                  } else {
                                    isSearching = true;
                                  }
                                });
                              },
                              child: Icon(
                                Icons.search_rounded,
                                color: kTextColor,
                                size: 30,
                              ),
                            ),
                            FloatingActionButton(
                              heroTag: null,
                              backgroundColor: kButtonBackground,
                              onPressed: () {
                                getUserData().then((value) {
                                  _showMyDialog(value);
                                });
                              },
                              child: Icon(
                                Icons.more_horiz_rounded,
                                color: kTextColor,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isSearching
                  ? SizedBox(
                      child: search(),
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 0.9,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              heroTag: null,
                              backgroundColor: Color(0xFF1D1D27),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: kSecondaryColor)),
                              child: Icon(
                                isLocating ? Icons.arrow_back_ios : Icons.info,
                                color: kSecondaryColor,
                              ),
                              onPressed: () {
                                if (isLocating) {
                                  setState(() {
                                    isLocating = false;
                                  });
                                } else {
                                  _showMyDialogInfo();
                                }
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              heroTag: null,
                              backgroundColor: Color(0xFF1D1D27),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: kSecondaryColor)),
                              child: Icon(
                                Icons.gps_fixed_rounded,
                                color: kSecondaryColor,
                              ),
                              onPressed: () {
                                moveToCurrentLocation();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ]),
      ),
    );
  }

  Future<void> _showMyDialogInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackGroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'homeT2',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ).tr(),
              ),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'images/cluster.png',
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'homeDesc1',
                    style: TextStyle(fontSize: 16, color: kTextColor),
                  ).tr(),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'images/map.png',
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'homeDesc2',
                    style: TextStyle(fontSize: 16, color: kTextColor),
                  ).tr(),
                ),
              ]),
            ],
          )),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'homeB3',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showMyDialogFilter() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          List<String> localFilters = appliedFilter.toList();
          return StatefulBuilder(
            builder: (ctx, state) => AlertDialog(
              backgroundColor: kBackGroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 8),
                      child: Text(
                        'homeT3',
                        style: TextStyle(
                            fontSize: 24,
                            color: kTextColor,
                            fontWeight: FontWeight.bold),
                      ).tr(),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: Column(
                      children: filter
                          .map((t) => CheckboxListTile(
                              activeColor: kSecondaryColor,
                              title: Text(
                                filterKeys[filter.indexOf(t)],
                                style: TextStyle(color: kTextColor),
                              ).tr(),
                              value: localFilters.contains(t),
                              onChanged: (val) {
                                state(() {
                                  if (val) {
                                    localFilters.add(t);
                                  } else {
                                    localFilters.remove(t);
                                  }
                                });
                              }))
                          .toList(),
                    ),
                  ),
                ],
              )),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(kSecondaryColor)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'homeB5',
                      style: TextStyle(color: kTextColor),
                    ).tr(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(kSecondaryColor)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'homeB6',
                      style: TextStyle(color: kTextColor),
                    ).tr(),
                  ),
                  onPressed: () {
                    setState(() {
                      appliedFilter = localFilters;
                    });
                    showReportData();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showMyDialog(User user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackGroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'homeT4',
            style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor),
          ).tr(),
          content: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user.name ?? "homeT5".tr(),
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  user.email ?? "homeT5".tr(),
                  style: TextStyle(fontSize: 16, color: kTextColor),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          EasyLocalization.of(context).setLocale(Locale('en'));
                        },
                        child: Text(
                          "English",
                          style: TextStyle(
                              fontSize: 16,
                              color: EasyLocalization.of(context).locale ==
                                      Locale('en')
                                  ? kSecondaryColor
                                  : kTextColor,
                              fontWeight: FontWeight.bold),
                        )),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 20, color: kTextColor),
                    ),
                    GestureDetector(
                        onTap: () {
                          EasyLocalization.of(context).setLocale(Locale('ar'));
                        },
                        child: Text(
                          "عربي",
                          style: TextStyle(
                              fontSize: 16,
                              color: EasyLocalization.of(context).locale ==
                                      Locale('ar')
                                  ? kSecondaryColor
                                  : kTextColor,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              )

              /*     Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  user.phoneNo ?? "loading",
                  style: TextStyle(fontSize: 16),
                ),
              ),*/
            ],
          )),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'homeB4',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              user: user,
                            )));
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'homeB3',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogReport() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackGroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'homeT6',
                style: TextStyle(color: kTextColor, fontSize: 24),
              ).tr(),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'homeB3',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        int type = 0;
        if (cluster.items.toList()[0].report.type == "crash_near_miss") {
          type = 1;
        }
        if (cluster.items.toList()[0].report.type == "hazard") {
          type = 2;
        }
        if (cluster.items.toList()[0].report.type == "threatening") {
          type = 3;
        }

        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          infoWindow: InfoWindow(
              title: filterKeys
                  .elementAt(
                      filter.indexOf(cluster.items.toList()[0].report.type))
                  .tr(),
              snippet: cluster.items
                  .toList()[0]
                  .report
                  .description /* "homeT7".tr(args: [
                cluster.items.toList()[0].report.date,
                 ?? ""
              ])*/
              ),
          onTap: () {
            cluster.items.forEach((p) => print(p));
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 100,
              text: cluster.isMultiple ? cluster.count.toString() : null,
              type: type),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size,
      {String text, int type}) async {
    if (kIsWeb) size = (size / 2).floor();

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = kSecondaryColor;
    final Paint paint2 = Paint()..color = Colors.white;
    final Paint paint3 = Paint()..color = Colors.black;
    var x;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    if (type != 0 && text == null) {
      x = await load("images/$type.png");

      canvas.drawImage(x, Offset(size / 6, size / 6), paint3);
    }

    if (text != null) {
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
      TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3.8,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Widget googleMap() {
    return GoogleMap(
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.085,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onCameraMove: (cameraPosition) {
          this.cameraPosition = cameraPosition;
          _manager.onCameraMove(cameraPosition);
        },
        onCameraMoveStarted: () {
          if (isLocating) {
            mapPickerController.mapMoving();
          }
        },
        onMapCreated: (controller) {
          controller.setMapStyle(_mapStyle);
          setState(() {
            _controller = controller;
            _controller.setMapStyle(_mapStyle);
            _manager.setMapId(controller.mapId);
          });
        },
        compassEnabled: true,
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        markers: markers,
        onCameraIdle: () {
          if (isLocating) {
            mapPickerController.mapFinishedMoving();
          }
          _manager.updateMap();
        });
  }

  void showReportData() {
    setState(() {
      isLoading = true;
    });
    marker.clear();
    markers.clear();
    getIncidentsData().then((value) {
      print("value" + value.length.toString());
      setState(() {
        isLoading = false;
        filteredReports =
            value.where((i) => appliedFilter.contains(i.type)).toList();
        filteredReports.forEach((element) {
          var place = Place(
              report: element,
              latLng: LatLng(element.location.lat, element.location.lng));
          marker.add(place);
        });
      });
    });
    if (currentLocation != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 7.0)));
    }
    _manager.updateMap();
  }

  Future<void> _showMyDialogRecordEnsure(temp) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackGroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "homeDesc3",
                style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ).tr(),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'homeB7',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'homeB8',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                getCurrentLocation();
                _showMyDialogReport();
                print(temp);
                String url = await uploadFileApi(File(temp), "");

                storeIncidentsData(Incident(
                  type: issueType,
                  crashData: CrashData(
                      type: "voice",
                      numberInvolvedBikes: "0",
                      numberInvolvedPedesterians: "0",
                      numberInvolvedVehicles: "0",
                      numberOfFatalities: "0",
                      numberOfInjuries: "0",
                      typeOfCollision: "voice",
                      reporterInvolved: false,
                      reporterType: "voice"),
                  hazardData: OtherData(type: "voice"),
                  threateningData: OtherData(type: "voice"),
                  file_ids: [url],
                  location: incident.Location(
                      lat: currentLocation.latitude,
                      lng: currentLocation.longitude),
                )).then((value) => showReportData());
              },
            ),
          ],
        );
      },
    );
  }

  String issueType;

  Future<void> _showMyDialogTypeChoose(temp) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackGroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "homeDesc4",
                style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ).tr(),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  't1',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () async {
                setState(() {
                  issueType = 'crash_near_miss';
                });
                Navigator.of(context).pop();
                _showMyDialogRecordEnsure(temp);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  't2',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () async {
                setState(() {
                  issueType = 'hazard';
                });
                Navigator.of(context).pop();
                _showMyDialogRecordEnsure(temp);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  't3',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () async {
                setState(() {
                  issueType = 'threatening';
                });
                Navigator.of(context).pop();
                _showMyDialogRecordEnsure(temp);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'homeB7',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  TextEditingController searchController;

  Widget search() {
    return Container(
      decoration: BoxDecoration(
        color: kBackGroundColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
            child: TextField(
              style: TextStyle(color: kTextColor),
              controller: searchController,
              decoration: InputDecoration(
                hoverColor: kTextColor,
                focusColor: kTextColor,
                iconColor: kTextColor,
                filled: true,
                fillColor: kBackGroundColor,
                prefixIcon: Icon(Icons.search),
                labelText: "homeT8".tr(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  borderSide: BorderSide(
                    color: kSecondaryColor,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  autoCompleteSearch(value);
                } else {
                  if (predictions.length > 0 && mounted) {
                    setState(() {
                      predictions.clear();
                    });
                  }
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: kButtonBackground,
                    child: Icon(
                      Icons.location_pin,
                      color: kSecondaryColor,
                    ),
                  ),
                  title: Text(
                    predictions[index].description,
                    style: TextStyle(color: kTextColor),
                  ),
                  onTap: () async {
                    setState(() {
                      isSearching = false;
                      searchController.clear();
                      Geocoder.local
                          .findAddressesFromQuery(
                              predictions[index].description)
                          .then((value) {
                        _controller.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(value.first.coordinates.latitude,
                                    value.first.coordinates.longitude),
                                zoom: 20)));
                      });

                      predictions.clear();
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus &&
                          currentFocus.focusedChild != null) {
                        currentFocus.focusedChild.unfocus();
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    print(value);
    AutocompleteResponse result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }
}
