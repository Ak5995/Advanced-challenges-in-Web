/*
 * Alex Yip 2021.
 */

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snapfile/widgets/delete_file_dialog.dart';
import 'package:snapfile/widgets/my_app_bar.dart';

import '../constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<File>> _futureFiles;

  @override
  void initState() {
    super.initState();

    _futureFiles = fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pop(context);
      return Container();
    }

    return Scaffold(
      appBar: MyAppBar(showUser: false),
      body: FutureBuilder(
          future: _futureFiles,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data as List;

              return data.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 128),
                      itemBuilder: (context, index) {
                        File file = data[index];

                        return Align(
                          child: SizedBox(
                            height: 200,
                            width: 1000,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          file.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'File ID: ${file.fid}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () async {
                                        final deleted = await showDialog<bool>(
                                          context: context,
                                          builder: (context) =>
                                              DeleteFileDialog(file),
                                        );

                                        if (deleted != null && deleted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Deleted ${file.name}'),
                                            ),
                                          );

                                          setState(() {
                                            _futureFiles = fetchFiles();
                                          });
                                        }
                                      },
                                      icon: Icon(Icons.delete),
                                      iconSize: 32,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: data.length,
                    )
                  : Center(
                      child: Text(
                      "You don't have any uploads.",
                      style: Theme.of(context).textTheme.headline3,
                    ));
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class File {
  final String fid;
  final String name;

  File({required this.fid, required this.name});

  factory File.fromJson(Map<String, dynamic> json) {
    return File(fid: json['fileId'], name: json['fileName']);
  }
}

Future<List<File>> fetchFiles() async {
  final path = "/user/get";
  final response = await http.get(Uri.parse(API_URL + path), headers: {
    "authorization":
        "Bearer " + await FirebaseAuth.instance.currentUser!.getIdToken(),
  });

  if (200 <= response.statusCode && response.statusCode < 300) {
    final json = jsonDecode(response.body) as Map;

    return json['data']['userFile']
        .map<File>((item) => File.fromJson(item))
        .toList();
  }

  throw Exception("Cannot retrieve records.");
}
