import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/model/user.dart';
import 'package:flutter_proj/service/service.dart';
import 'package:flutter_proj/ui/elements/bottom_bar.dart';

class ProfilePage extends StatelessWidget
{

  final Service serv ;
  final User user ;
  final  String title;

  const ProfilePage(this.serv,this.user,this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(25.0),
        child:Column(children:  [TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: user.name,
          ),
          readOnly: true,
        ),TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: user.username
          ),
          readOnly: true,
        ),TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: user.password
          ),
          readOnly: true,
        ),TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: user.tip
          ),
          readOnly: true,
        )
        ]))), bottomNavigationBar: bottomBar(serv,title));
  }
}
