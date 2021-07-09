/*
 * Alex Yip 2021.
 */

import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:snapfile/routes.dart';
import 'package:snapfile/utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key) {
    FluroRouter router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error);
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Snapfile',
            darkTheme: ThemeData(
              primarySwatch: Colors.orange,
              accentColor: Colors.orangeAccent,
              brightness: Brightness.dark,
            ),
            themeMode: ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Application.router.generator,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
