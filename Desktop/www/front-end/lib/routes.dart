/*
 * Alex Yip 2021.
 */

import 'package:fluro/fluro.dart';
import 'package:snapfile/route_handlers.dart';

class Routes {
  static String root = "/";
  static String dashboard = "/dashboard";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = unknownHandler;

    router.define(root, handler: rootHandler);

    router.define(dashboard, handler: dashboardRouteHandler);
  }
}
