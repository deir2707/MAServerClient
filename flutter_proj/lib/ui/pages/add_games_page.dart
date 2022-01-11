import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/service/service.dart';
import 'package:flutter_proj/ui/elements/bottom_bar.dart';

import '../elements/custom_alert.dart';

class AddMeciPage extends StatelessWidget {
  final Service serv;
  final String title;
  final String echipa1;
  final String echipa2;
  final String goluri1;
  final String goluri2;
  final bool shouldPop;

  const AddMeciPage(this.serv, this.title, this.echipa1, this.echipa2,
      this.goluri1, this.goluri2,
      [this.shouldPop = false])
      : super();
  @override
  Widget build(BuildContext context) {
    var echipa1Controller = TextEditingController(text: echipa1);
    var echipa2Controller = TextEditingController(text: echipa2);
    var goluri1Controller = TextEditingController(text: goluri1);
    var goluri2Controller = TextEditingController(text: goluri2);
    Future<void> onAdd() async {
      try {
        var a = await serv.addMeci(
            echipa1Controller.text,
            echipa2Controller.text,
            int.parse(goluri1Controller.text),
            int.parse(goluri2Controller.text));
        if (a) {
          show1ButtonAlertDialog(context, "Meci adaugat sau updatat!",
              "Meciul a fost adaugat sau updatat!", serv);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          if (shouldPop) {
            Navigator.of(context).pop();
          }
          return;
        }

        show1ButtonAlertDialog(context, "Numele echipelor este gresit",
            "Numele echipelor este gresit", serv);
      } on FormatException catch (_, e) {
        show1ButtonAlertDialog(context, "Scorul trebuie sa fie un numar",
            "Scorul trebuie sa fie un numar", serv);
      }
    }

    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Prima Echipa',
                    ),
                    controller: echipa1Controller,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'A doua echipa'),
                    controller: echipa2Controller,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Numarul de goluri pentru prima echipa'),
                    controller: goluri1Controller,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Numarul de goluri pentru a doua echipa'),
                    controller: goluri2Controller,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: const Color(0xFFefa880),
                      primary: const Color(0xFF66302d),
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    onPressed: onAdd,
                    child: const Text('Meci salvat'),
                  ),
                ],
              ))),
      bottomNavigationBar: bottomBar(serv, title),
    );
  }
}
