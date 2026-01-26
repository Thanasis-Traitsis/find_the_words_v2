import 'package:flutter/material.dart';

enum DeviceOrientation {
  portrait,
  landscape,
}

DeviceOrientation getDeviceOrientation(BuildContext context) {
  final Orientation orientation = MediaQuery.of(context).orientation;

  if (orientation == Orientation.portrait) {
    return DeviceOrientation.portrait;
  } else {
    return DeviceOrientation.landscape;
  }
}