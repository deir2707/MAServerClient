import 'package:flutter_proj/model/entity.dart';

class User extends Entity<int>{
  User(this.id, this.username, this.password, this.name, this.tip):super.emptyConstructor()
  {
    if(tip!=null) {
      this.tip = tip;
    } else {
      this.tip ="Utilizator" ;
    }
  }
  int id;
  String username;
  String password;
  String name;
  String tip;
}