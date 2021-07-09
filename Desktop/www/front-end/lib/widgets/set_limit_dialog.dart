/*
 * Alex Yip 2021.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapfile/utils.dart';

class SetLimitDialog extends StatefulWidget {
  @override
  _SetLimitDialogState createState() => _SetLimitDialogState();
}

class _SetLimitDialogState extends State<SetLimitDialog> {
  final _accessLimitController = TextEditingController(text: "∞");

  DateTime? _timeLimit;

  String get _getFormattedTimeLimit =>
      _timeLimit != null ? simpleDateFormat.format(_timeLimit!) : "Unset";

  void _setAccessLimitText(String s) => setState(() {
        _accessLimitController.text = s;
        _accessLimitController.selection = TextSelection.fromPosition(
            TextPosition(offset: _accessLimitController.text.length));
      });

  @override
  void dispose() {
    _accessLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Access Limits'),
      content: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        defaultColumnWidth: IntrinsicColumnWidth(),
        columnWidths: {1: FixedColumnWidth(10)},
        children: [
          TableRow(
            children: [
              Text('No. of accesses'),
              Container(),
              AccessLimitWidget(
                _accessLimitController,
                _setAccessLimitText,
              ),
            ],
          ),
          TableRow(children: [SizedBox(height: 16), Container(), Container()]),
          TableRow(
            children: [
              Text("Time limit"),
              Container(),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextButton(
                        child: Text(
                          _getFormattedTimeLimit,
                        ),
                        onPressed: () async {
                          final timeLimit = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );

                          setState(() => _timeLimit = timeLimit);
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _timeLimit != null,
                    child: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        setState(() => _timeLimit = null);
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
                context, Limits(_accessLimitController.text, _timeLimit));
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}

class AccessLimitWidget extends StatelessWidget {
  final TextEditingController _accessLimitController;
  final Function _setAccessLimitText;

  AccessLimitWidget(
    this._accessLimitController,
    this._setAccessLimitText, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          splashRadius: 20,
          onPressed: () {
            String s = _accessLimitController.text;

            if (s == "∞" || s.isEmpty || s == "1") {
              _setAccessLimitText("∞");
            } else {
              int i = int.parse(s);
              if (i > 1) {
                _setAccessLimitText("${i - 1}");
              }
            }
          },
          icon: Icon(Icons.remove),
        ),
        SizedBox(
          width: 64,
          child: TextField(
            textAlign: TextAlign.center,
            controller: _accessLimitController,
            autofocus: true,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                String newString = newValue.text;
                int? newInt = int.tryParse(newString);

                if ((newInt != null && newInt >= 1) ||
                    newString == "∞" ||
                    newString == "") {
                  return newValue;
                }

                return oldValue;
              })
            ],
          ),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            String s = _accessLimitController.text;

            if (s.isEmpty || s == "∞") {
              s = "1";
            } else {
              s = "${int.parse(s) + 1}";
            }

            _setAccessLimitText(s);
          },
          icon: Icon(Icons.add),
        )
      ],
    );
  }
}

class Limits {
  final String accessLimit;
  final DateTime? timeLimit;

  Limits(this.accessLimit, this.timeLimit);
}
