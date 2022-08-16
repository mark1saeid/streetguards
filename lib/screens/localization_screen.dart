
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:streetguards/screens/profile_screen.dart';

import '../util/palette.dart';

class LocalizationScreen extends StatefulWidget {
  const LocalizationScreen({Key key}) : super(key: key);
  static String id = 'Localization_Screen';
  @override
  State<LocalizationScreen> createState() => _LocalizationScreenState();
}

class _LocalizationScreenState extends State<LocalizationScreen> {
  Locale locale = Locale('null') ;

  @override
  Widget build(BuildContext context) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              locale = Locale('en');
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color:  locale.languageCode == 'en'?kSecondaryColor:Colors.transparent,
                                  border: Border.all(
                                    width: 4,
                                    color: kSecondaryColor,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Text("EN",style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.15,fontWeight: FontWeight.bold),)
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              locale = Locale('ar');
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: locale.languageCode == 'ar'?kSecondaryColor:Colors.transparent,
                                  border: Border.all(
                                    width: 4,
                                    color: kSecondaryColor,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Text("AR",style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.15,fontWeight: FontWeight.bold),)
                          ),
                        )
                      ],
                    ),
                SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(kSecondaryColor),
                        ),
                        onPressed: () async {
                  if(locale.languageCode != "null"){

                    EasyLocalization.of(context).setLocale(locale);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>ProfileScreen()));
                  }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
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
}
