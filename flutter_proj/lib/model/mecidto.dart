import 'entity.dart';

class MeciDTO extends Entity<int>{
  MeciDTO(this.id, this.Echipa1, this.Echipa2,this.echipa1img,this.echipa2img, this.goluri1, this.goluri2): super.emptyConstructor();
  int id;
  String Echipa1;
  String echipa1img;
  String echipa2img;
  String Echipa2;
  int goluri1;
  int goluri2;

}