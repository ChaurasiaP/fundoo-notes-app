import 'dart:math';

import 'package:flutter/material.dart';

// initializing some variables which will be used and repeated multiple times throughout
var searchBarBG = Colors.white70;
var allRoutesBG = Colors.blue[50];
var routesBG = Colors.blue[200];
var sideMenuBG = Colors.blue[200];
var activeTab = Colors.blue[700];
var buttonsColor = Colors.blue.shade900;
var tabItemColor = Colors.white;

// optional list of colors to assign random colors to notes, everytime the app is opened
// currently not in use
List<Color?> notesColors = [
  Colors.redAccent[100],
  Colors.lime[100],
  Colors.cyan[100],
  Colors.deepOrangeAccent[100],
  Colors.lightGreen[100],
  Colors.lightBlueAccent[100],
  Colors.purpleAccent[100],
  Colors.indigoAccent[100],
  Colors.deepOrangeAccent[100]
];
Color? colorGenerator() {
  var value = Random().nextInt(notesColors.length);
  return notesColors[value];
}

var sideMenuHeader = const LinearGradient(colors: [Colors.lightBlueAccent,Colors.lightGreenAccent, Colors.redAccent], begin: Alignment.bottomLeft, end: Alignment.topRight);