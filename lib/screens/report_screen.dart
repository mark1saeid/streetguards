import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streetguards/model/incidents.dart';
import 'package:streetguards/model/report.dart';
import 'package:streetguards/screens/home_screen.dart';

import '../helpers/helpermethods.dart';
import '../services/media_service.dart';
import '../services/report_service.dart';
import '../util/palette.dart';

class ReportScreen extends StatefulWidget {
  static String id = 'Report_Screen';
  final String location;

  const ReportScreen({Key key, this.location}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<String> subTypeList = ["Select"];
  List<String> subTypeListKeys = ['reportT1'];
  int selectedType = 0;

  List<String> mainType = [
    'Select',
    'crash_near_miss',
    'hazard',
    'threatening',
  ];
  List<String> mainTypeKeys = [
    'reportT1',
    't1',
    't2',
    't3',
  ];

  List<String> subType1List = ['Select', 'Crash', 'Near Miss'];
  List<String> subType3List = [
    'Select',
    'Vandalism',
    'Harassment',
    'Insecurity',
    'Other',
  ];
  List<String> subType2List = [
    'Select',
    'Road',
    'Sidewalk',
    'Bus',
    'Bike Lane',
    'Other',
  ];

  List<String> subType1ListKey = ['reportT1', 'reportSub1T1', 'reportSub1T2'];
  List<String> subType3ListKey = [
    'reportT1',
    'reportSub2T1',
    'reportSub2T2',
    'reportSub2T3',
    'reportT2',
  ];
  List<String> subType2ListKey = [
    'reportT1',
    'reportSub3T1',
    'reportSub3T2',
    'reportSub3T3',
    'reportSub3T4',
    'reportT2',
  ];

  String imagePath;
  String takenFrom;
  Incident report = Incident();
  bool isSending = false;

  @override
  void initState() {
    report.file_ids = [];
    report.crashData = CrashData();
    report.threateningData = OtherData();
    report.hazardData = OtherData();
    report.location = Location(
        lat: Report().toLatLng(widget.location).latitude,
        lng: Report().toLatLng(widget.location).longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: isSending
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitPulse(
                        color: kSecondaryColor,
                        size: 50,
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'reportDesc1'.tr(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16, top: 8),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                //   Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: kTextColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.025,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'reportT3',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: kTextColor),
                                ).tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'reportT4',
                            style: TextStyle(color: kTextColor, fontSize: 16),
                          ).tr(),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Color(0xFFF6F6F6), // Set border color
                                width: 3.0), // Set border width
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  DateFormat dateFormat =
                                      DateFormat("yyyy/MM/dd");
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    setState(() {
                                      report.date = dateFormat.format(date);
                                    });
                                  }, currentTime: DateTime.now());
                                },
                                child: DropdownButton(
                                  hint: Text(
                                    report.date ?? 'reportT1'.tr(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  isExpanded: true,
                                  value: report.date ?? 'reportT1'.tr(),
                                  underline: SizedBox(),
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 20,
                                  style: TextStyle(
                                      color: kTextColor, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'reportT5',
                            style: TextStyle(color: kTextColor, fontSize: 16),
                          ).tr(),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Color(0xFFF6F6F6), // Set border color
                                width: 3.0), // Set border width
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton<String>(
                                dropdownColor: kBackGroundColor,
                                isExpanded: true,
                                value: report.type ?? "Select",
                                underline: SizedBox(),
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 20,
                                style:
                                    TextStyle(color: kTextColor, fontSize: 16),
                                onChanged: (String newValue) {
                                  setState(() {
                                    report.type = newValue;
                                    report.issueSubType = 'Select';
                                    if (newValue == mainType[1]) {
                                      subTypeList = subType1List;
                                      subTypeListKeys = subType1ListKey;
                                      selectedType = 1;
                                    }
                                    if (newValue == mainType[2]) {
                                      subTypeList = subType2List;
                                      subTypeListKeys = subType2ListKey;
                                      selectedType = 2;
                                    }
                                    if (newValue == mainType[3]) {
                                      subTypeList = subType3List;
                                      subTypeListKeys = subType3ListKey;
                                      selectedType = 3;
                                    }
                                    if (newValue == mainType[0]) {
                                      subTypeList = ['Select'];
                                      subTypeListKeys = ['reportT1'.tr()];
                                      selectedType = 0;
                                    }
                                  });
                                },
                                items: mainType.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      mainTypeKeys[mainType.indexOf(value)],
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ).tr(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'reportT6',
                            style: TextStyle(color: kTextColor, fontSize: 16),
                          ).tr(),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Color(0xFFF6F6F6), // Set border color
                                width: 3.0), // Set border width
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton<String>(
                                dropdownColor: kBackGroundColor,
                                underline: SizedBox(),
                                isExpanded: true,
                                value: report.issueSubType ?? "Select",
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 20,
                                style:
                                    TextStyle(color: kTextColor, fontSize: 16),
                                onChanged: (String newValue) {
                                  setState(() {
                                    if (selectedType == 0) {
                                      report.threateningData.type = null;
                                      report.hazardData.type = null;
                                      report.crashData.type = null;
                                    }
                                    if (selectedType == 1) {
                                      report.crashData.type = newValue;
                                      report.threateningData.type = null;
                                      report.hazardData.type = null;
                                    }
                                    if (selectedType == 2) {
                                      report.hazardData.type = newValue;
                                      report.threateningData.type = null;
                                      report.crashData.type = null;
                                    }
                                    if (selectedType == 3) {
                                      report.threateningData.type = newValue;
                                      report.hazardData.type = null;
                                      report.crashData.type = null;
                                    }
                                    report.issueSubType = newValue;
                                  });
                                },
                                items: subTypeList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  print(subTypeList.indexOf(value));
                                  print(value);
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      subTypeListKeys[
                                          subTypeList.indexOf(value)],
                                      style: TextStyle(fontSize: 16),
                                    ).tr(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      selectedType == 1
                          ? Column(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'reportT7',
                                      style: TextStyle(
                                          color: kTextColor, fontSize: 16),
                                    ).tr(),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'reportT8',
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 16),
                                          ).tr(),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: TextField(
                                            onChanged: (value) {
                                              report?.crashData
                                                  ?.numberInvolvedBikes = value;
                                            },
                                            style: TextStyle(color: kTextColor),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 20.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF6F6F6),
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'reportT9',
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 16),
                                          ).tr(),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: TextField(
                                            style: TextStyle(color: kTextColor),
                                            onChanged: (value) {
                                              report?.crashData
                                                      ?.numberInvolvedVehicles =
                                                  value;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 20.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF6F6F6),
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'reportT10',
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 16),
                                          ).tr(),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: TextField(
                                            style: TextStyle(color: kTextColor),
                                            onChanged: (value) {
                                              report?.crashData
                                                      ?.numberInvolvedPedesterians =
                                                  value;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 20.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF6F6F6),
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'reportDesc2',
                                      style: TextStyle(
                                          color: kTextColor, fontSize: 16),
                                    ).tr(),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      fillColor:
                                          MaterialStateProperty.all(kTextColor),
                                      value: true,
                                      activeColor: kTextColor,
                                      groupValue:
                                          report?.crashData?.reporterInvolved,
                                      onChanged: (val) {
                                        setState(() {
                                          report?.crashData?.reporterInvolved =
                                              val;
                                        });
                                      },
                                    ),
                                    Text(
                                      'profileTgl1',
                                      style: TextStyle(color: kTextColor),
                                    ).tr(),
                                    Radio(
                                      fillColor:
                                          MaterialStateProperty.all(kTextColor),
                                      value: false,
                                      activeColor: kTextColor,
                                      groupValue:
                                          report?.crashData?.reporterInvolved,
                                      onChanged: (val) {
                                        setState(() {
                                          report?.crashData?.reporterInvolved =
                                              val;
                                        });
                                      },
                                    ),
                                    Text(
                                      'profileTgl2',
                                      style: TextStyle(color: kTextColor),
                                    ).tr(),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'reportDesc3',
                                      style: TextStyle(
                                          color: kTextColor, fontSize: 16),
                                    ).tr(),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.center,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color(
                                              0xFFF6F6F6), // Set border color
                                          width: 3.0), // Set border width
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: DropdownButton<String>(
                                          dropdownColor: kBackGroundColor,
                                          isExpanded: true,
                                          value:
                                              report.crashData?.reporterType ??
                                                  "Select",
                                          underline: SizedBox(),
                                          icon:
                                              const Icon(Icons.arrow_downward),
                                          iconSize: 20,
                                          style: TextStyle(
                                              color: kTextColor, fontSize: 16),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              report.crashData.reporterType =
                                                  newValue;
                                            });
                                          },
                                          items: <List<String>>[
                                            ["Select", 'reportT1'],
                                            ["Motorist", 'reportT11'],
                                            ["Pedestrian", 'reportT12'],
                                            [
                                              "Public Transit User",
                                              'reportT13'
                                            ],
                                            ["Cyclist", 'reportT14'],
                                          ].map<DropdownMenuItem<String>>(
                                              (List<String> value) {
                                            return DropdownMenuItem<String>(
                                              value: value.first,
                                              child: Text(
                                                value.last,
                                                style: TextStyle(fontSize: 16),
                                              ).tr(),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'reportT15',
                                      style: TextStyle(
                                          color: kTextColor, fontSize: 16),
                                    ).tr(),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.center,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color(
                                              0xFFF6F6F6), // Set border color
                                          width: 3.0), // Set border width
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: DropdownButton<String>(
                                          dropdownColor: kBackGroundColor,
                                          isExpanded: true,
                                          value: report
                                                  .crashData?.typeOfCollision ??
                                              "Select",
                                          underline: SizedBox(),
                                          icon:
                                              const Icon(Icons.arrow_downward),
                                          iconSize: 20,
                                          style: TextStyle(
                                              color: kTextColor, fontSize: 16),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              report.crashData.typeOfCollision =
                                                  newValue;
                                            });
                                          },
                                          items: <List<String>>[
                                            ["Select", 'reportT1', ""],
                                            [
                                              "Rear End",
                                              'reportT16',
                                              "images/icons/rearEnd.png"
                                            ],
                                            [
                                              "Head On",
                                              'reportT17',
                                              "images/icons/headOn.png"
                                            ],
                                            [
                                              "Side Swipe",
                                              'reportT18',
                                              "images/icons/sideSwipe.png"
                                            ],
                                            [
                                              "Overtaking",
                                              'reportT19',
                                              "images/icons/overTaking.png"
                                            ],
                                            [
                                              "Right Turn",
                                              'reportT20',
                                              "images/icons/rightTurn.png"
                                            ],
                                            [
                                              "Left Turn",
                                              'reportT21',
                                              "images/icons/leftTurn.png"
                                            ],
                                            ["Other", 'reportT2', ""],
                                          ].map<DropdownMenuItem<String>>(
                                              (List<String> value) {
                                            return DropdownMenuItem<String>(
                                              value: value.first,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  value.last == ""
                                                      ? SizedBox()
                                                      : Image.asset(
                                                          value.last,
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                  Text(
                                                    value[1],
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ).tr(),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              'reportT22',
                                              style: TextStyle(
                                                  color: kTextColor,
                                                  fontSize: 16),
                                            ).tr(),
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: TextField(
                                              style:
                                                  TextStyle(color: kTextColor),
                                              onChanged: (value) {
                                                report?.crashData
                                                    ?.numberOfInjuries = value;
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 16.0,
                                                        horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFF6F6F6),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kSecondaryColor,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              'reportT23',
                                              style: TextStyle(
                                                  color: kTextColor,
                                                  fontSize: 16),
                                            ).tr(),
                                          ),
                                          Container(
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: TextField(
                                              style:
                                                  TextStyle(color: kTextColor),
                                              onChanged: (value) {
                                                report?.crashData
                                                        ?.numberOfFatalities =
                                                    value;
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 16.0,
                                                        horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFF6F6F6),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kSecondaryColor,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'reportT24',
                            style: TextStyle(color: kTextColor, fontSize: 16),
                          ).tr(),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          style: TextStyle(color: kTextColor),
                          onChanged: (value) {
                            report.description = value;
                          },
                          decoration: InputDecoration(
                            //     hintText: 'Description',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF6F6F6), width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kSecondaryColor, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          //Normal textInputField will be displayed
                          maxLines:
                              5, // when user presses enter it will adapt to it
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'reportT25',
                            style: TextStyle(color: kTextColor, fontSize: 16),
                          ).tr(),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await showImagePicker();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xFF1D1D27),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Center(
                              child: imagePath == null
                                  ? Icon(
                                      Icons.image_rounded,
                                      color: kSecondaryColor,
                                      size: MediaQuery.of(context).size.width *
                                          0.15,
                                    )
                                  : Image.file(
                                      File(imagePath),
                                      fit: BoxFit.fill,
                                    )),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
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
                            setState(() {
                              isSending = true;
                            });

                            if (report.type != null &&
                                    report.issueSubType != null &&
                                    report.description != null &&
                                    report.date != null
                                // &&  imagePath != null
                                ) {
                              if (imagePath != null) {
                                String url = await uploadFileApi(
                                    File(imagePath), takenFrom);
                                report.file_ids = [url];
                              }

                              if (selectedType == 1) {
                                if (report?.crashData?.numberInvolvedBikes !=
                                        null &&
                                    report?.crashData?.numberInvolvedVehicles !=
                                        null &&
                                    report?.crashData?.numberInvolvedPedesterians !=
                                        null &&
                                    report?.crashData?.reporterInvolved !=
                                        null &&
                                    report?.crashData?.numberOfFatalities !=
                                        null &&
                                    report?.crashData?.numberOfInjuries !=
                                        null &&
                                    report?.crashData?.typeOfCollision !=
                                        null &&
                                    report?.crashData?.reporterType != null) {
                                  //   report.numberOfInvolved = bikes + vehicles + pedesterians;
                                  storeIncidentsData(report).then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  });
                                } else {
                                  setState(() {
                                    isSending = false;
                                  });
                                  showCheckReport();
                                }
                              } else {
                                storeIncidentsData(report).then((value) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                });
                              }
                            } else {
                              setState(() {
                                isSending = false;
                              });
                              showCheckReport();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              "homeB8",
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
    );
  }

  Future<void> showCheckReport() async {
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
                'reportDesc4',
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

  Future<void> showImagePicker() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackGroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Text(
              'reportT26',
              style: TextStyle(color: kTextColor, fontSize: 20),
            ).tr(),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'reportT27',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                HelperMethods().getImage(ImageSource.gallery).then((value) {
                  if (value != "" || value != null) {
                    setState(() {
                      takenFrom = 'Gallery';
                      imagePath = value;
                    });
                  }
                });
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'reportT28',
                  style: TextStyle(color: kTextColor),
                ).tr(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                HelperMethods().getImage(ImageSource.camera).then((value) {
                  if (value != "" || value != null) {
                    setState(() {
                      takenFrom = 'Camera';
                      imagePath = value;
                    });
                  }
                });
              },
            ),
            /*   ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kSecondaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: kTextColor),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),*/
          ],
        );
      },
    );
  }
}
