import 'package:flutter/material.dart';

const Color kPurpleColor = Color(0xFF9053EB);
const Color kLightGray = Color(0xFFD0D0D0);
const Color kDarkGray = Color(0xFFABABAB);

const Map<int, Color> kMaterialPurpleColorSwatch = {
  50: Color.fromRGBO(0x90, 0x53, 0xEB, .1),
  100: Color.fromRGBO(0x90, 0x53, 0xEB, .2),
  200: Color.fromRGBO(0x90, 0x53, 0xEB, .3),
  300: Color.fromRGBO(0x90, 0x53, 0xEB, .4),
  400: Color.fromRGBO(0x90, 0x53, 0xEB, .5),
  500: Color.fromRGBO(0x90, 0x53, 0xEB, .6),
  600: Color.fromRGBO(0x90, 0x53, 0xEB, .7),
  700: Color.fromRGBO(0x90, 0x53, 0xEB, .8),
  800: Color.fromRGBO(0x90, 0x53, 0xEB, .9),
  900: Color.fromRGBO(0x90, 0x53, 0xEB, 1),
};
const MaterialColor kMaterialPurpleColor = MaterialColor(0xFF9053EB, kMaterialPurpleColorSwatch);

const TextStyle kPurpleTextStyle = TextStyle(color: kPurpleColor);
