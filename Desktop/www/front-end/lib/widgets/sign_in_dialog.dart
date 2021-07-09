/*
 * Alex Yip 2021-04-07.
 * sign_in_dialog.dart last modified 2021-04-07.
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../utils.dart';

class SignInDialog extends StatefulWidget {
  @override
  _SignInDialogState createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  final _pwFocusNode = FocusNode();

  String? _emailError;
  String? _pwError;

  _onSubmit() async {
    final email = _emailController.text;
    final pw = _pwController.text;

    if (email.isEmpty) {
      setState(() {
        _emailError = "Please enter an email.";
      });
    }

    if (pw.isEmpty) {
      setState(() {
        _pwError = "Please enter a password.";
      });
    }

    if (email.isEmpty || pw.isEmpty) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pw);

      print(userCredential);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signed in"),
        ),
      );

      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            _emailError = "This email is invalid.";
            break;
          default:
            print("FirebaseAuthException: ${e.code}/${e.message}");
            _emailError = "Email/password is invalid.";
            _pwError = "Email/password is invalid.";
            break;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _pwFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text("Sign in"),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailError,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() {
                _emailError = null;
              }),
              onSubmitted: (value) {
                _pwFocusNode.requestFocus();
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pwController,
              focusNode: _pwFocusNode,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _pwError,
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) => setState(() {
                _pwError = null;
              }),
              onSubmitted: (value) => _onSubmit(),
            ),
            SizedBox(height: 24),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: _onSubmit,
                child: Text("Sign in"),
              ),
            ),
            SizedBox(height: 16),
            SignInButton(
              Buttons.GoogleDark,
              onPressed: onGoogleSubmit,
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}
