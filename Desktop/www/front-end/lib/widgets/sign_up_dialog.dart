/*
 * Alex Yip 2021-04-07.
 * sign_up_dialog.dart last modified 2021-04-07.
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../utils.dart';

class SignUpDialog extends StatefulWidget {
  @override
  _SignUpDialogState createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _pw2Controller = TextEditingController();

  final _pwFocusNode = FocusNode();
  final _pw2FocusNode = FocusNode();

  String? _emailError;
  String? _pwError;
  String? _pw2Error;

  _onSubmit() async {
    final email = _emailController.text;
    final pw = _pwController.text;
    final pw2 = _pw2Controller.text;

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

    if (pw2.isEmpty) {
      setState(() {
        _pw2Error = "Please enter a password.";
      });
    }

    if (email.isEmpty || pw.isEmpty || pw2.isEmpty) return;

    if (pw != pw2) {
      setState(() {
        _pwError = "Passwords do not match";
        _pw2Error = "Passwords do not match";
      });
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pw);

      print(userCredential);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signed up"),
        ),
      );

      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _emailError = "This email s already in use.";
            break;
          case 'invalid-email':
            _emailError = "This email is invalid.";
            break;
          case 'weak-password':
            _pwError = "The password provided is too weak.";
            break;
          default:
            _emailError = "Email/password is invalid.";
            _pwError = "Email/password is invalid.";
            _pw2Error = "Email/password is invalid.";
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
    _pw2Controller.dispose();
    _pwFocusNode.dispose();
    _pw2FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
              onSubmitted: (value) {
                _pw2FocusNode.requestFocus();
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pw2Controller,
              focusNode: _pw2FocusNode,
              decoration: InputDecoration(
                labelText: 'Confirm password',
                errorText: _pw2Error,
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) => setState(() {
                _pw2Error = null;
              }),
              onSubmitted: (value) => _onSubmit(),
            ),
            SizedBox(height: 24),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: _onSubmit,
                child: Text("Sign up"),
              ),
            ),
            SizedBox(height: 16),
            SignInButton(
              Buttons.GoogleDark,
              text: "Sign up with Google",
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
