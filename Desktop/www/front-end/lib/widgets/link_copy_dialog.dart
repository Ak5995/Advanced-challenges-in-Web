import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkCopyDialog extends StatelessWidget {
  final String link;

  LinkCopyDialog(this.link, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Download link"),
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      content: InkWell(
        onTap: () {
          Clipboard.setData(new ClipboardData(text: link));
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Container(
            child: Row(
              children: [
                Text(
                  link,
                  style: GoogleFonts.robotoMono(),
                ),
                SizedBox(width: 16),
                Icon(Icons.copy),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
