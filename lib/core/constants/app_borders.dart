import 'package:flutter/material.dart';

class AppBorders {
  static const double smallBorderWidth = 1.0;
  static const double mediumBorderWidth = 2.0;
  static const double largeBorderWidth = 4.0;

  static const BorderRadius smallBorderRadiusConst = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius regularBorderRadiusConst = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius bigBorderRadiusConst = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius hugeBorderRadiusConst = BorderRadius.all(Radius.circular(20.0));

  static BorderRadius get smallBorderRadius => BorderRadius.circular(4.0);
  static BorderRadius get regularBorderRadius => BorderRadius.circular(8.0);
  static BorderRadius get bigBorderRadius => BorderRadius.circular(12.0);
  static BorderRadius get hugeBorderRadius => BorderRadius.circular(20.0);
}
