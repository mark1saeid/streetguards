import 'package:flutter/material.dart';

Color kExtraDarkPrimaryColor = Color(0xFF231942);
Color kDarkPrimaryColor = Color(0xFF5e548e);
Color kButtonBackground = Color(0xFF1D1D27);

Color kPrimaryColor = Color(0xFFC933EB);
Color kSecondaryColor = Color(0xFF50C1E9);
Color kBackGroundColor = Color(0xFF424242);
Color kLightPrimaryColor = Color(0xFFbe95c4);
Color kExtraLightPrimaryColor = Color(0xFFe0b1cb);


Color kPrimaryTextColor = Color(0xFF212121);
Color kSecondaryTextColor = Color(0xFF757575);
Color kDividerColor = Color(0xFFBDBDBD);

Color kTextColor = Color(0xFFFFFFFF);

var kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: kTextColor),
  labelStyle: TextStyle(color: kTextColor),
  fillColor: kTextColor,
  focusColor: kTextColor,
  hoverColor: kTextColor,
  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kSecondaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

