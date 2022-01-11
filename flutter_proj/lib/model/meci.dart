import 'package:flutter_proj/database/database_games.dart';
import 'package:flutter_proj/model/entity.dart';

class Meci extends Entity<int> {
  Meci(this.id, this.Echipa1, this.Echipa2, this.goluri1, this.goluri2)
      : super.emptyConstructor();
  int id;
  String Echipa1;
  String Echipa2;
  int goluri1;
  int goluri2;

  Map<String, Object?> toJson() => {
        //MeciFields.id : id,
        MeciFields.Echipa1: Echipa1,
        MeciFields.Echipa2: Echipa2,
        MeciFields.goluri1: goluri1,
        MeciFields.goluri2: goluri2,
      };
  Map<String, Object?> toJson2() => {
        "id": id,
        MeciFields.Echipa1: Echipa1,
        MeciFields.Echipa2: Echipa2,
        MeciFields.goluri1: goluri1,
        MeciFields.goluri2: goluri2,
      };
}
