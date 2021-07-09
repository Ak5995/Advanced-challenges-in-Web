/*
 * Alex Yip 2021.
 */

import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:drop_zone/drop_zone.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:snapfile/constants.dart';
import 'package:snapfile/utils.dart';
import 'package:snapfile/widgets/link_copy_dialog.dart';
import 'package:snapfile/widgets/my_app_bar.dart';
import 'package:snapfile/widgets/set_limit_dialog.dart';
import 'package:universal_html/html.dart';

const FILE_FIELD_NAME = "uploadFile";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isUploading = false;

  @override
  Widget build(BuildContext context) {
    const COMMIT_SHA =
        String.fromEnvironment('COMMIT_SHA', defaultValue: 'LOCAL');
    const COMMIT_TIMESTAMP = String.fromEnvironment('COMMIT_TIMESTAMP',
        defaultValue: '2000-02-03T00:00:00+08:00');

    return Scaffold(
      appBar: MyAppBar(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DropZone(
                  onDrop: (List<File>? files) {
                    if (files != null) {
                      File file = files[0];

                      FileReader fileReader = FileReader();

                      fileReader.onLoad.first.then((event) {
                        _uploadFile(
                          context,
                          new MultipartFile.fromBytes(
                            FILE_FIELD_NAME,
                            fileReader.result as Uint8List,
                            filename: file.name,
                          ),
                        );
                      });

                      fileReader.readAsArrayBuffer(file);
                    }
                  },
                  child: Card(
                    // TODO drag&drop
                    margin: const EdgeInsets.symmetric(
                      horizontal: 128,
                      vertical: 64,
                    ),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(4),
                      strokeWidth: 2.5,
                      dashPattern: [10],
                      color: Theme.of(context).accentColor,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_upload,
                              size: 128,
                            ),
                            SizedBox(height: 64),
                            Text(
                              "Drop your files here!",
                              style: TextStyle(fontSize: 72),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () =>
                                  _onUploadFileButtonClick(context),
                              child: Text("Pick file"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child:
                    Text('Version: $COMMIT_SHA, built on: $COMMIT_TIMESTAMP'),
              )
            ],
          ),
          Visibility(
            visible: isUploading,
            child: Container(
              color: Colors.grey[900]!.withAlpha(0xD0),
              child: Center(
                child: SizedBox.fromSize(
                  child: CircularProgressIndicator(strokeWidth: 8),
                  size: Size.square(60),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onUploadFileButtonClick(BuildContext context) async {
    setState(() => isUploading = true);

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withReadStream: true);

    if (result?.files.single != null) {
      final PlatformFile file = result!.files.single;

      _uploadFile(
        context,
        new MultipartFile(
          FILE_FIELD_NAME,
          file.readStream!,
          file.size,
          filename: file.name,
        ),
      );
    }
  }

  void _uploadFile(BuildContext context, MultipartFile multipartFile) async {
    setState(() => isUploading = true);

    final request =
        MultipartRequest("POST", Uri.parse(API_URL + "/dud/upload"));

    request.files.add(multipartFile);

    final limits = await showDialog<Limits>(
      context: context,
      builder: (context) => SetLimitDialog(),
    );

    if (limits == null) {
      return setState(() => isUploading = false);
    }

    if (FirebaseAuth.instance.currentUser != null) {
      request.headers.addAll({
        "authorization":
            "Bearer " + await FirebaseAuth.instance.currentUser!.getIdToken(),
      });
    }

    if (limits.accessLimit != "∞") {
      request.fields.addAll({
        "accessLimit": limits.accessLimit,
      });
    }

    if (limits.timeLimit != null) {
      request.fields.addAll({
        "timeLimit": simpleDateFormat.format(limits.timeLimit!),
      });
    }

    try {
      final resp = await request.send();

      if (200 <= resp.statusCode && resp.statusCode < 300) {
        final respString = await resp.stream.bytesToString();

        setState(() => isUploading = false);

        await showDialog(
            context: context, builder: (context) => LinkCopyDialog(respString));
      } else {
        throw resp.reasonPhrase ?? Error();
      }
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Server error: $e')));
    } finally {
      setState(() => isUploading = false);
    }
  }
}
