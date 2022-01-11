import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/model/user.dart';
import 'package:flutter_proj/service/service.dart';
import 'package:flutter_proj/ui/pages/profile_page.dart';

import '../../main.dart';
import '../pages/add_games_page.dart';

class bottomBar extends StatelessWidget {
  final Service serv;

  final String title;

  const bottomBar(this.serv, this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => {
        if (index == 0)
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(serv, title: title)))
          },
        if (index == 1)
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddMeciPage(serv, title, "", "", "", "")))
          },
        if (index == 2)
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        serv,
                        User(1, "edoardo dochitoiu", "dedo", "dedo",
                            "administrator"),
                        title)))
          },
      },
      unselectedItemColor: const Color(0xFFFFFFFF),
      selectedItemColor: const Color(0xFFFFFFFF),
      backgroundColor: const Color(0xFF00802b),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: Color(0xFFFFFFFF),
          ),
          label: 'My games',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, color: Color(0xFFFFFFFF)),
          label: 'Add game',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined, color: Color(0xFFFFFFFF)),
          label: 'Profile',
        ),
      ],
    );
  }
}
