import 'package:flutter_proj/database/database_games.dart';
import 'package:flutter_proj/model/echipa.dart';
import 'package:flutter_proj/repo/repository.dart';
import 'package:sqflite/sqflite.dart';

class EchipeRepositoryDB implements IEchipaDBRepo {
  late Repository<Echipa, int> _repo;
  late Database db;
  Future<void> init() async {
    db = await MyDatabaseImplementation.gamesDatabase.database;
    final result = await db.query(tableEchipe);
    List<Echipa> echipe = [];
    for (var echipa in result) {
      echipe.add(fromJsonEchipa(echipa));
    }
    _repo = Repository<Echipa, int>.initRepo(echipe);
  }

  @override
  Future<Echipa> addElement(Echipa val) async {
    final id = await db.insert(tableEchipe, val.toJson());
    val.id = id;
    _repo.add(val);
    return val;
  }

  @override
  Future deleteElement(int id) async {
    var val = db
        .delete(tableEchipe, where: "${EchipaFields.id} = ?", whereArgs: [id]);
    _repo.delete(id);
    await val;
  }

  @override
  Future<List<Echipa>> getAllElements() async {
    var res = _repo.getAll();
    res.sort((a, b) => b.nrpuncte.compareTo(a.nrpuncte));
    return res;
  }

  @override
  Future<Echipa?> getEchipaByName(String nume) async {
    try {
      var a = _repo.items.where((val) => val.nume == nume).first;
      return a;
    } on StateError {
      return null;
    }
  }

  @override
  Future<Echipa> getOneElement(int id) async {
    return _repo.getOne(id);
  }

  Echipa fromJsonEchipa(Map<String, Object?> json) {
    return Echipa(
        json[EchipaFields.id] as int,
        json[EchipaFields.nrpuncte] as int,
        json[EchipaFields.nume] as String,
        json[EchipaFields.imageUrl] as String,
        json[EchipaFields.stadion] as String,
        json[EchipaFields.detinator] as String);
  }

  @override
  Future editElement(Echipa val) async {
    var res = await db.update(tableEchipe, val.toJson(),
        where: '${EchipaFields.id} = ?', whereArgs: [val.id]);
    _repo.update(val);
  }

  @override
  Future destroyAll() async {
    var val = db.delete(tableEchipe, where: null);
    await val;
    _repo.destroyList();
  }
}
