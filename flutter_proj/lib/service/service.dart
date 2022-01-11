import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_proj/database/database_games.dart';
import 'package:flutter_proj/model/echipa.dart';
import 'package:flutter_proj/model/meci.dart';
import 'package:flutter_proj/model/mecidto.dart';
import 'package:http/http.dart' as http;

class Service extends ChangeNotifier {
  final IEchipaDBRepo _echipaRepo;
  final IMeciDBRepo _meciRepo;
  Service(this._echipaRepo, this._meciRepo);
  String baseUrl = "http://10.0.2.2:8080/games/";
  Echipa fromJsonEchipa(Map<String, Object?> json) {
    return Echipa(
        json['id'] as int,
        json['nrpuncte'] as int,
        json['nume'] as String,
        json['imageUrl'] as String,
        json['stadion'] as String,
        json['detinator'] as String);
  }

  Meci fromJsonMeci(Map<String, Object?> json) {
    return Meci(
        json['id'] as int,
        json['echipa1'] as String,
        json['echipa2'] as String,
        json['goluri1'] as int,
        json['goluri2'] as int);
  }

  Future<List<Meci>> getAllMeciuri2() async {
    return _meciRepo.getAllElements();
  }

  Future<List<Meci>> getAllMeciuri() async {
    debugPrint("ENTERED:getAllMeciuri");
    http.Response response;
    try {
      response = await http
          .get(Uri.parse(baseUrl + "meciuri"))
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      throw Exception("Please check your connection!");
    }
    if (response.statusCode == 200) {
      debugPrint("STATUS CODE 200");
      await _meciRepo.destroyAll();
      var listOfElements = jsonDecode(response.body);
      for (var item in listOfElements) {
        print(item);
        await _meciRepo.addElement(fromJsonMeci(item));
        print(item);
      }
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load meciuri!');
    }
    debugPrint("EXITED:getAllMeciuri");
    return await _meciRepo.getAllElements();
  }

  Future<List<Echipa>> getAllEchipe2() async {
    return _echipaRepo.getAllElements();
  }

  Future<List<Echipa>> getAllEchipe() async {
    debugPrint("ENTERED:getAllEchipe");
    http.Response response;
    try {
      response = await http
          .get(Uri.parse(baseUrl + "echipe"))
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      throw Exception("Please check your connection!");
    }
    if (response.statusCode == 200) {
      debugPrint("STATUS CODE 200");
      await _echipaRepo.destroyAll();
      var listOfElements = jsonDecode(response.body);
      for (var item in listOfElements) {
        await _echipaRepo.addElement(fromJsonEchipa(item));
      }
    } else {
      debugPrint(response.body);
      throw Exception('Failed to load books!');
    }
    debugPrint("EXITED:getAllEchipe");
    return await _echipaRepo.getAllElements();
  }

  Future addEchipa(int nrpuncte, String nume, String imageUrl, String stadion,
      String detinator) async {
    await _echipaRepo
        .addElement(Echipa(-1, nrpuncte, nume, imageUrl, stadion, detinator));
    notifyListeners();
  }

  Future<Meci> findMeci(String Echipa1, String Echipa2) async {
    List<Meci> meciuri = [];
    for (var a in await _meciRepo.getAllElements()) {
      if (a.Echipa1 == Echipa1 && a.Echipa2 == Echipa2) {
        return a;
      }
    }
    if (meciuri.isNotEmpty) {
      return meciuri[0];
    } else {
      meciuri.insert(0, new Meci(-123, "ceva", "ceva", 1, 1));
      return meciuri[0];
    }
  }

  Future editMeciR(Meci m) async {
    debugPrint("ENTERED:editMeciR");
    http.Response response;
    try {
      debugPrint(jsonEncode(m.toJson2()));
      response = await http.put(Uri.parse(baseUrl + "meciuri/"),
          body: jsonEncode(m.toJson2()),
          headers: {
            "Content-Type": "application/json"
          }).timeout(const Duration(seconds: 3));
    } catch (e) {
      throw Exception("Please check your connection!");
    }
    if (response.statusCode == 200) {
      debugPrint("STATUS CODE 200");
      await _meciRepo.editElement(m);
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("Meci SUCCESSFULLY EDITED");
    } else {
      debugPrint(response.body);
      throw Exception('Failed to edit meci!');
    }
    debugPrint("EXITED:editMeciR");
  }

  Future editEchipaR(Echipa m) async {
    debugPrint("ENTERED:editEchipaR");
    http.Response response;
    try {
      response = await http.put(Uri.parse(baseUrl + "echipe/"),
          body: jsonEncode(m.toJson2()),
          headers: {
            "Content-Type": "application/json"
          }).timeout(const Duration(seconds: 3));
    } catch (e) {
      throw Exception("Please check your connection!");
    }
    if (response.statusCode == 200) {
      debugPrint("STATUS CODE 200");
      await _echipaRepo.editElement(m);
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("Meci SUCCESSFULLY EDITED");
    } else {
      debugPrint(response.body);
      throw Exception('Failed to edit meci!');
    }
    debugPrint("EXITED:editMeciR");
  }

  Future editMeci(
      int id, String Echipa1, String Echipa2, int goluri1, int goluri2) async {
    var a = await _echipaRepo.getEchipaByName(Echipa1);
    var b = await _echipaRepo.getEchipaByName(Echipa2);
    var c = await findMeci(Echipa1, Echipa2);
    if (goluri1 == goluri2 && c.goluri1 < c.goluri2) {
      b?.nrpuncte -= 2;
      a?.nrpuncte += 1;
    } else if (goluri1 == goluri2 && c.goluri1 > c.goluri2) {
      a?.nrpuncte -= 2;
      b?.nrpuncte += 1;
    } else if (goluri1 > goluri2 && c.goluri1 == c.goluri2) {
      a?.nrpuncte += 2;
      b?.nrpuncte -= 1;
    } else if (goluri1 < goluri2 && c.goluri1 == c.goluri2) {
      b?.nrpuncte += 2;
      a?.nrpuncte -= 1;
    } else if (goluri1 < goluri2 && c.goluri1 > c.goluri2) {
      a?.nrpuncte -= 3;
      b?.nrpuncte += 3;
    } else if (goluri1 > goluri2 && c.goluri1 < c.goluri2) {
      b?.nrpuncte -= 3;
      a?.nrpuncte += 3;
    }
    await editMeciR(Meci(c.id, Echipa1, Echipa2, goluri1, goluri2));
    await editEchipaR(a!);
    await editEchipaR(b!);
    notifyListeners();
  }

  Future addMeciR(Meci m) async {
    debugPrint("ENTERED:addMeciR");

    http.Response response;
    try {
      response = await http.post(Uri.parse(baseUrl + "meciuri/"),
          body: jsonEncode(m.toJson2()),
          headers: {
            "Content-Type": "application/json"
          }).timeout(const Duration(seconds: 3));
    } catch (e) {
      throw Exception("Please check your connection!");
    }
    if (response.statusCode == 200) {
      debugPrint("STATUS CODE 200");
      await _meciRepo.addElement(m);
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("Meci SUCCESSFULLY ADDED");
    } else {
      debugPrint(response.body);
      throw Exception('Failed to add meci!');
    }
    debugPrint("EXITED:addMeciR");
  }

  Future addMeci(
      String Echipa1, String Echipa2, int goluri1, int goluri2) async {
    var a = await _echipaRepo.getEchipaByName(Echipa1);
    var b = await _echipaRepo.getEchipaByName(Echipa2);
    var c = await findMeci(Echipa1, Echipa2);
    if (c.id == -123) {
      if (goluri1 < goluri2) {
        b?.nrpuncte += 3;
      } else if (goluri1 > goluri2) {
        a?.nrpuncte += 3;
      } else if (goluri1 == goluri2) {
        a?.nrpuncte += 1;
        b?.nrpuncte += 1;
      }
      if (a?.nume == Echipa1 && b?.nume == Echipa2) {
        await addMeciR(Meci(-1, Echipa1, Echipa2, goluri1, goluri2));
        await editEchipaR(a!);
        await editEchipaR(b!);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } else {
      editMeci(c.id, Echipa1, Echipa2, goluri1, goluri2);
      return true;
    }
  }

  Future deleteMeci(int id) async {
    debugPrint("ENTERED:deleteMeci");
    var c = await _meciRepo.getOneElement(id);
    var a = await _echipaRepo.getEchipaByName(c.Echipa1);
    var b = await _echipaRepo.getEchipaByName(c.Echipa2);
    if (c.goluri1 < c.goluri2) {
      b?.nrpuncte -= 3;
    } else if (c.goluri1 > c.goluri2) {
      a?.nrpuncte -= 3;
    } else if (c.goluri1 == c.goluri2) {
      a?.nrpuncte -= 1;
      b?.nrpuncte -= 1;
    }
    await editEchipaR(a!);
    await editEchipaR(b!);

    http.Response response;
    try {
      response = await http
          .delete(Uri.parse(baseUrl + "meciuri/" + id.toString()))
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      throw Exception("Please check your connection!");
    }
    if (response.statusCode == 200) {
      debugPrint("STATUS CODE 200");
      await _meciRepo.deleteElement(id);
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("Meci SUCCESSFULLY DELETED");
    } else {
      debugPrint(response.body);
      throw Exception('Failed to delete meci!');
    }
    debugPrint("EXITED:deleteMeci");
    notifyListeners();
  }

  Future<Echipa?> getEchipaByName(String name) async {
    return await _echipaRepo.getEchipaByName(name);
  }

  Future<List<MeciDTO>> getAllMeciuriDTO() async {
    var meciuri = await _meciRepo.getAllElements();
    List<MeciDTO> list = [];
    for (var meci in meciuri) {
      var c = await getEchipaByName(meci.Echipa1);
      var d = await getEchipaByName(meci.Echipa2);
      list.add(MeciDTO(meci.id, meci.Echipa1, meci.Echipa2, c!.imageUrl,
          d!.imageUrl, meci.goluri1, meci.goluri2));
    }
    return list;
  }
}
