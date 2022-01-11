import 'package:flutter_proj/database/database_games.dart';
import 'package:flutter_proj/model/entity.dart';

class Echipa extends Entity<int> {
  Echipa(this.id, this.nrpuncte, this.nume, this.imageUrl, this.stadion,
      this.detinator)
      : super.emptyConstructor();
  int id;
  int nrpuncte;
  String nume;
  String imageUrl;
  String stadion;
  String detinator;
  Map<String, Object?> toJson() => {
        EchipaFields.nrpuncte: nrpuncte,
        EchipaFields.nume: nume,
        EchipaFields.imageUrl: imageUrl,
        EchipaFields.stadion: stadion,
        EchipaFields.detinator: detinator,
      };
  Map<String, Object?> toJson2() => {
        "_id": id,
        EchipaFields.nrpuncte: nrpuncte,
        EchipaFields.nume: nume,
        EchipaFields.imageUrl: imageUrl,
        EchipaFields.stadion: stadion,
        EchipaFields.detinator: detinator,
      };

  void setId(int id) {
    this.id = id;
  }
}
