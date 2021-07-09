/*
 * Alex Yip 2021.
 */

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:snapfile/pages/dashboard.dart';
import 'package:snapfile/pages/home.dart';
import 'package:snapfile/pages/unknown.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return HomeScreen();
});

var dashboardRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return DashboardScreen();
});

var unknownHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return UnknownScreen();
});
