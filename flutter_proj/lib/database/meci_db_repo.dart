import 'package:flutter_proj/database/database_games.dart';
import 'package:flutter_proj/model/meci.dart';
import 'package:flutter_proj/repo/repository.dart';
import 'package:sqflite/sqflite.dart';

class MeciRepositoryDB implements IMeciDBRepo {
  late Repository<Meci, int> _repo;
  late Database db;

  Future<void> init() async {
    db = await MyDatabaseImplementation.gamesDatabase.database;
    final result = await db.query(tableMeciuri);
    List<Meci> meciuri = [];
    for (var review in result) {
      meciuri.add(fromJsonMeci(review));
    }
    _repo = Repository<Meci, int>.initRepo(meciuri);
  }

  @override
  Future<Meci> addElement(Meci val) async {
    final id = await db.insert(tableMeciuri, val.toJson());
    val.id = id;
    _repo.add(val);
    return val;
  }

  @override
  Future deleteElement(int id) async {
    var val =
        db.delete(tableMeciuri, where: "${MeciFields.id} = ?", whereArgs: [id]);
    _repo.delete(id);
    await val;
  }

  @override
  Future<List<Meci>> getAllElements() async {
    return _repo.getAll();
  }

  @override
  Future<Meci> getOneElement(int id) async {
    return _repo.getOne(id);
  }

  @override
  Future<List<Meci>> getReviewsByUser(int idUser) async {
    return _repo.items.where((val) => val.id == idUser).toList();
  }

  Meci fromJsonMeci(Map<String, Object?> json) {
    return Meci(
        json[MeciFields.id] as int,
        json[MeciFields.Echipa1] as String,
        json[MeciFields.Echipa2] as String,
        json[MeciFields.goluri1] as int,
        json[MeciFields.goluri2] as int);
  }

  @override
  Future editElement(Meci val) async {
    var res = await db.update(tableMeciuri, val.toJson(),
        where: '${MeciFields.id} = ?', whereArgs: [val.id]);
    _repo.update(val);
  }

  @override
  Future destroyAll() async {
    var val = db.delete(tableMeciuri, where: null);
    await val;
    _repo.destroyList();
  }
}
