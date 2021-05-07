import 'package:flutter/material.dart';

Future<void> showAlertDialog(
    {@required BuildContext context,
    @required String content,
    @required String title,
    @required String cancelActionText}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text(cancelActionText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
