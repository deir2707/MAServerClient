import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/model/echipa.dart';
import 'package:flutter_proj/service/service.dart';
import 'package:fluttericon/font_awesome_icons.dart';

PreferredSizeWidget searchBar(
    String title, BuildContext context, Service serv, List<Echipa> echipe) {
  return AppBar(
    backgroundColor: const Color(0xFF00802b),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)),
      onPressed: () {},
    ),
    actions: [
      IconButton(
        onPressed: () {
          showEchipeTable(context, echipe);
        },
        icon: const Icon(FontAwesome.soccer_ball, color: Color(0xFFFFFFFF)),
      )
    ],
    centerTitle: true,
  );
}

showEchipeTable(BuildContext context, List<Echipa> listaEchipe) {
  var x = Scaffold(
      body: Center(
    child: ListView.builder(
      itemBuilder: (context, index) {
        Echipa echipa = listaEchipe[index];
        return Card(
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: Image(
                    image: NetworkImage(echipa.imageUrl),
                    width: 100,
                    height: 200,
                  ),
                ),
              ),
              Expanded(flex: 4, child: Center(child: Text(echipa.nume))),
              Expanded(
                  flex: 2,
                  child: Center(child: Text(echipa.nrpuncte.toString())))
            ],
          ),
        );
      },
      itemCount: listaEchipe.length,
    ),
  ));
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return x;
    },
  );
}
