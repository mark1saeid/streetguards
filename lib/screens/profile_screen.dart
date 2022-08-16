import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:streetguards/model/user.dart';
import 'package:streetguards/screens/splash_screen.dart';
import 'package:streetguards/services/profile_service.dart';

import '../helpers/helpermethods.dart';
import '../util/palette.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'Profile Screen';
  User user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User userProfile = User();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  //TextEditingController phoneController = TextEditingController();

  TextEditingController professionController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController experienceController = TextEditingController();

  initialize() {
    nameController.text = userProfile.name;
    emailController.text = userProfile.email;
    //  phoneController.text = userProfile.phoneNo;

    professionController.text = userProfile.profession;
    experienceController.text = userProfile.drivingExperience.toString();
    birthDateController.text = userProfile.date;
  }

  @override
  void initState() {
    if (widget.user != null) {
      userProfile = widget.user;
      initialize();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: Container(
        color: kBackGroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kBackGroundColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('profileTitle',
                                        style: TextStyle(
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20))
                                    .tr(),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'profileSubDesc1',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: kTextColor, fontSize: 12),
                            ).tr(),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: nameController,
                              style: TextStyle(color: kTextColor),
                              cursorColor: kTextColor,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'profileL1'.tr(),
                              ),
                              onChanged: (value) {
                                userProfile.name = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: kTextColor),
                              cursorColor: kTextColor,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'profileL2'.tr(),
                              ),
                              onChanged: (value) {
                                userProfile.email = value;
                              },
                            ),
                          ),
                          /*      Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: phoneController,
                              style: TextStyle(color: kTextColor),
                              cursorColor: kTextColor,
                              keyboardType: TextInputType.phone,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Mobile Number',
                              ),
                              onChanged: (value) {
                                userProfile.phoneNo = value;
                              },
                            ),
                          ),  */
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                DateFormat dateFormat =
                                    DateFormat("yyyy/MM/dd");
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true, onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  setState(() {
                                    birthDateController.text =
                                        dateFormat.format(date);
                                    userProfile.birthDate =
                                        dateFormat.format(date);
                                  });
                                }, currentTime: DateTime.now());
                              },
                              child: TextField(
                                controller: birthDateController,
                                enabled: false,
                                style: TextStyle(color: kTextColor),
                                cursorColor: kTextColor,
                                decoration: kTextFieldDecoration.copyWith(
                                  labelText: 'profileL3'.tr(),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'profileL4',
                                style:
                                    TextStyle(color: kTextColor, fontSize: 16),
                              ).tr(),
                            ),
                          ),
                          Row(
                            children: [
                              Radio<bool>(
                                fillColor:
                                    MaterialStateProperty.all(kTextColor),
                                value: true,
                                activeColor: kTextColor,
                                groupValue: userProfile.gender,
                                onChanged: (bool val) {
                                  setState(() {
                                    userProfile.gender = true;
                                  });
                                },
                              ),
                              Text(
                                'profileG1',
                                style: TextStyle(color: kTextColor),
                              ).tr(),
                              Radio<bool>(
                                fillColor:
                                    MaterialStateProperty.all(kTextColor),
                                value: false,
                                activeColor: kTextColor,
                                groupValue: userProfile.gender,
                                onChanged: (bool val) {
                                  setState(() {
                                    userProfile.gender = false;
                                  });
                                },
                              ),
                              Text(
                                'profileG2',
                                style: TextStyle(color: kTextColor),
                              ).tr(),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          /*    Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('More Information',
                                    style: TextStyle(
                                        color: kTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'please provide this information .',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: kTextColor, fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),*/
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: professionController,
                              style: TextStyle(color: kTextColor),
                              cursorColor: kTextColor,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'profileL5'.tr(),
                              ),
                              onChanged: (value) {
                                userProfile.profession = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                showPickerNumber(context);
                              },
                              child: TextField(
                                enabled: false,
                                keyboardType: TextInputType.number,
                                controller: experienceController,
                                style: TextStyle(color: kTextColor),
                                cursorColor: kTextColor,
                                decoration: kTextFieldDecoration.copyWith(
                                  labelText: 'profileL6'.tr(),
                                ),
                                onChanged: (value) {
                                  //      userProfile.drivingExperience = int.parse(value);
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'profileL7',
                                style:
                                    TextStyle(color: kTextColor, fontSize: 16),
                              ).tr(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 5),
                            child: Text(
                              'profileSubDesc4',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: kTextColor, fontSize: 12),
                            ).tr(),
                          ),
                          Row(
                            children: [
                              Radio(
                                fillColor:
                                    MaterialStateProperty.all(kTextColor),
                                value: true,
                                activeColor: kTextColor,
                                groupValue: userProfile.isTransportationExpert,
                                onChanged: (val) {
                                  setState(() {
                                    userProfile.isTransportationExpert = val;
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
                                groupValue: userProfile.isTransportationExpert,
                                onChanged: (val) {
                                  setState(() {
                                    userProfile.isTransportationExpert = val;
                                  });
                                },
                              ),
                              Text(
                                'profileTgl2',
                                style: TextStyle(color: kTextColor),
                              ).tr(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 5),
                            child: Text(
                              'profileSubDesc2',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: kTextColor, fontSize: 12),
                            ).tr(),
                          ),
                          Row(
                            children: [
                              Radio(
                                fillColor:
                                    MaterialStateProperty.all(kTextColor),
                                value: true,
                                activeColor: kTextColor,
                                groupValue: userProfile.isExpert,
                                onChanged: (val) {
                                  setState(() {
                                    userProfile.isExpert = val;
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
                                groupValue: userProfile.isExpert,
                                onChanged: (val) {
                                  setState(() {
                                    userProfile.isExpert = val;
                                  });
                                },
                              ),
                              Text(
                                'profileTgl2',
                                style: TextStyle(color: kTextColor),
                              ).tr(),
                            ],
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'profileL8',
                                style:
                                    TextStyle(color: kTextColor, fontSize: 16),
                              ).tr(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 5),
                            child: Text(
                              'profileSubDesc3',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: kTextColor, fontSize: 12),
                            ).tr(),
                          ),
                          Row(
                            children: [
                              Radio(
                                fillColor:
                                    MaterialStateProperty.all(kTextColor),
                                value: true,
                                activeColor: kTextColor,
                                groupValue: userProfile.carOwnership,
                                onChanged: (val) {
                                  setState(() {
                                    userProfile.carOwnership = val;
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
                                groupValue: userProfile.carOwnership,
                                onChanged: (val) {
                                  setState(() {
                                    userProfile.carOwnership = val;
                                  });
                                },
                              ),
                              Text(
                                'profileTgl2',
                                style: TextStyle(color: kTextColor),
                              ).tr(),
                            ],
                          ),
                          privacyPolicyLinkAndTermsOfService(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kSecondaryColor),
                              ),
                              onPressed: () async {
                                if (passError() == 0) {
                                  createUserData(userProfile);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SplashScreen()));
                                } else {
                                  _showMyDialogProfile(getMessage(passError()));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "profileB1",
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int passError() {
    int passError;
    if (userProfile.name == null) {
      passError = 1;
    }
    /*else if (userProfile.phoneNo == null) {
      passError = 2;
    } */
    else if (userProfile.profession == null) {
      passError = 3;
    } else if (userProfile.birthDate == null) {
      passError = 4;
    } else if (userProfile.gender == null) {
      passError = 5;
    }
    /*else if (userProfile.phoneNo.length < 10) {
      passError = 6;
    } */
    else if (userProfile.email == null) {
      passError = 7;
    } else if (userProfile.drivingExperience == null) {
      passError = 8;
    } else if (userProfile.carOwnership == null) {
      passError = 9;
    } else {
      passError = 0;
    }
    return passError;
  }

  String getMessage(int errorNo) {
    String errorText;
    switch (errorNo) {
      case 1:
        errorText = 'Enter Name';
        break;
      case 2:
        errorText = 'Enter Your Phone Number';
        break;
      case 3:
        errorText = 'Enter Profession';
        break;
      case 4:
        errorText = 'Enter Birth Date';
        break;
      case 5:
        errorText = 'Enter Select Gender';
        break;
      case 6:
        errorText = 'Phone Number should have a least 10 numbers';
        break;
      case 7:
        errorText = 'Enter Email';
        break;
      case 8:
        errorText = 'Enter Years Of Driving Experience';
        break;
      case 9:
        errorText = 'Select Car Ownership';
        break;
    }
    return errorText;
  }

  Future<void> _showMyDialogProfile(String input) async {
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
              input,
              style: TextStyle(color: kTextColor, fontSize: 16),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(kSecondaryColor)),
                child: Text(
                  'OK',
                  style: TextStyle(color: kTextColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: GestureDetector(
              onTap: () {
                HelperMethods().launchURL(
                    "https://www.freeprivacypolicy.com/live/920ade6a-a779-4235-919d-bcec9b77451d");
              },
              child: Text.rich(TextSpan(
                  text: 'profileP1'.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: kTextColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'profileP2'.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: kTextColor,
                          decoration: TextDecoration.underline),
                    )
                    //])
                  ])),
            ),
          ),
          Expanded(
              flex: 1,
              child: Icon(
                Icons.privacy_tip_rounded,
                color: kSecondaryColor,
              ))
        ],
      ),
    );
  }

  showPickerNumber(BuildContext context) {
    Picker(
        containerColor: kBackGroundColor,
        //  headerColor: kTextColor,
        textStyle: TextStyle(color: kTextColor, fontSize: 20),
        backgroundColor: kBackGroundColor,
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 99),
        ]),
        hideHeader: true,
        title: new Text(
          "Please Select",
          style: TextStyle(color: kTextColor),
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            userProfile.drivingExperience = picker.getSelectedValues().first;
            experienceController.text =
                picker.getSelectedValues().first.toString();
          });
          print(value.toString());
          print(picker.getSelectedValues());
        }).showDialog(context);
  }
}
