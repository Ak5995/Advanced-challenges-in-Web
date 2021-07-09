/*
 * Alex Yip 2021.
 */

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:snapfile/constants.dart';
import 'package:snapfile/pages/dashboard.dart';

class DeleteFileDialog extends StatefulWidget {
  final file;

  DeleteFileDialog(this.file, {Key? key}) : super(key: key);

  @override
  _DeleteFileDialogState createState() => _DeleteFileDialogState();
}

class _DeleteFileDialogState extends State<DeleteFileDialog> {
  var _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm Delete"),
      content: Text(
        "Are you sure you want to delete ${widget.file.name}?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() => _isDeleting = true);

            await deleteFile(context, widget.file);

            Navigator.pop(context, true);
          },
          child: _isDeleting
              ? SizedBox.fromSize(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                  size: Size.square(16),
                )
              : Text("OK"),
        )
      ],
    );
  }
}

Future<bool> deleteFile(BuildContext context, File file) async {
  final path = "/user/dashboardDelete";
  final response = await http.post(Uri.parse(API_URL + path),
      headers: {
        "authorization":
            "Bearer " + await FirebaseAuth.instance.currentUser!.getIdToken(),
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "data": {
          "fileIds": [file.fid]
        }
      }));

  if (200 <= response.statusCode && response.statusCode < 300) {
    print(response.body);

    return true;
  }

  throw Exception("Cannot delete file");
}
