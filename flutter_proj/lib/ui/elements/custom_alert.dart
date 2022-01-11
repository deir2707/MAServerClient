import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/service/service.dart';

show1ButtonAlertDialog(
    BuildContext context, String title, String message, Service serv) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

show2ButtonAlertDialog(BuildContext context, VoidCallback onDeletePress,
    VoidCallback onUpdatePress) {
  // set up the buttons
  Widget deleteButton = TextButton(
    child: Text("Delete"),
    onPressed: onDeletePress,
  );
  Widget updateButton = TextButton(
    child: Text("Add/Update"),
    onPressed: onUpdatePress,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("AlertDialog"),
    content: const Text("Alege o optiune?"),
    actions: [
      updateButton,
      deleteButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
