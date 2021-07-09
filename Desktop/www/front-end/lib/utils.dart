/*
 * Alex Yip 2021.
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:intl/intl.dart';

onGoogleSubmit() async {
  GoogleAuthProvider googleProvider = GoogleAuthProvider();
  await FirebaseAuth.instance.signInWithRedirect(googleProvider);
}

class Application {
  static FluroRouter router = FluroRouter();
}

DateFormat get simpleDateFormat => DateFormat('yyyy-MM-dd');
