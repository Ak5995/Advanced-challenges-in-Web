/*
 * Alex Yip 2021.
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snapfile/constants.dart';
import 'package:snapfile/utils.dart';
import 'package:snapfile/widgets/sign_in_dialog.dart';
import 'package:snapfile/widgets/sign_up_dialog.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final bool showUser;

  MyAppBar({Key? key, this.showUser = true}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(72.0);
}

class _MyAppBarState extends State<MyAppBar> {
  List<Widget> getLoggedInActions(BuildContext context, User user) {
    final actions = <Widget>[];

    if (widget.showUser) {
      actions.add(Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 16.0,
        ),
        child: TextButton(
          onPressed: () {
            Application.router
                .navigateTo(
                  context,
                  '/dashboard',
                  transition: TransitionType.native,
                )
                .then((value) => setState(() {}));
          },
          child: Text(user.displayName ?? user.email ?? "Dashboard"),
        ),
      ));
    }

    return actions +
        [
          AppBarActionButton(
            text: "Sign out",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              setState(() {});

              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
          )
        ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.getRedirectResult(),
      builder: (context, snapshot) {
        List<Widget> actions = [];
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            actions = [
              AppBarActionButton(
                text: "Sign up",
                onPressed: () async {
                  if (await _showSignUpDialog(context) ?? false) {
                    setState(() {});
                  }
                },
              ),
              AppBarActionButton(
                text: "Sign in",
                onPressed: () async {
                  if (await _showSignInDialog(context) ?? false) {
                    setState(() {});
                  }
                },
              ),
            ];
          } else {
            actions = getLoggedInActions(
              context,
              (snapshot.data as UserCredential).user!,
            );
          }
        } else {
          actions = [
            Padding(
              padding: EdgeInsets.all(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(),
              ),
            )
          ];
        }

        if (FirebaseAuth.instance.currentUser != null) {
          actions = getLoggedInActions(
            context,
            FirebaseAuth.instance.currentUser!,
          );
        }

        return AppBar(
          toolbarHeight: 72.0,
          title: Text(
            APP_NAME.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.audiowide(
              textStyle: Theme.of(context).appBarTheme.titleTextStyle,
              fontSize: 32.0,
              letterSpacing: 15.0,
            ),
          ),
          actions: actions + [SizedBox(width: 8)],
        );
      },
    );
  }
}

Future<bool?> _showSignUpDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => SignUpDialog(),
    );

Future<bool?> _showSignInDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => SignInDialog(),
    );

class AppBarActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  AppBarActionButton({Key? key, required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 16.0,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
