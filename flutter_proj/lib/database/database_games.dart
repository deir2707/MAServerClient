import 'dart:async';

import 'package:flutter_proj/model/echipa.dart';
import 'package:flutter_proj/model/entity.dart';
import 'package:flutter_proj/model/meci.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class IFutureRepository<T extends Entity, ID> {
  Future<T> addElement(T val);
  Future deleteElement(ID id);
  Future editElement(T val);
  Future<T> getOneElement(ID id);
  Future<List<T>> getAllElements();
  Future destroyAll();
}

abstract class IEchipaDBRepo extends IFutureRepository<Echipa, int> {
  Future<Echipa?> getEchipaByName(String title);
  Future<void> init();
}

abstract class IMeciDBRepo extends IFutureRepository<Meci, int> {
  Future<void> init();
}

class MyDatabaseImplementation {
  static final MyDatabaseImplementation gamesDatabase =
      MyDatabaseImplementation._init();
  static const dbName = 'games.db';
  static const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const integerType = 'INTEGER NOT NULL';
  static const textType = 'TEXT NOT NULL';
  static const createTableEchipe =
      '''CREATE TABLE IF NOT EXISTS $tableEchipe(${EchipaFields.id} $idType,${EchipaFields.nrpuncte} $integerType,
    ${EchipaFields.nume} $textType, ${EchipaFields.imageUrl} $textType, ${EchipaFields.stadion} $textType,
    ${EchipaFields.detinator} $integerType);''';

  static const createTableMeciuri =
      '''CREATE TABLE IF NOT EXISTS $tableMeciuri(${MeciFields.id} $idType,${MeciFields.Echipa1} $textType,
    ${MeciFields.Echipa2} $textType, ${MeciFields.goluri1} $integerType, ${MeciFields.goluri2} $integerType);''';

  static const createTableUsers =
      '''CREATE TABLE IF NOT EXISTS $tableUsers(${UserFields.id} $idType,${UserFields.username} $textType,
    ${UserFields.password} $textType, ${UserFields.name} $textType, ${UserFields.tip} $textType);''';

  static Database? _database;
  MyDatabaseImplementation._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('games.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future close() async {
    final db = await gamesDatabase.database;
    db.close();
  }

  Future _createDB(Database db, int version) async {
    await db.execute(createTableUsers);
    await db.execute(createTableEchipe);
    await db.execute(createTableMeciuri);
  }

  Future<void> recreateDB() async {
    final db = await gamesDatabase.database;
    print("Destroying database...");
    await db.execute("DROP TABLE IF EXISTS $tableMeciuri");
    await db.execute("DROP TABLE IF EXISTS $tableEchipe");
    await db.execute("DROP TABLE IF EXISTS $tableUsers");
    print("Creating database...");
    await db.execute(createTableUsers);
    await db.execute(createTableEchipe);
    await db.execute(createTableMeciuri);
  }
}

const String tableEchipe = 'echipe';
const String tableUsers = 'users';
const String tableMeciuri = 'meciuri';

class EchipaFields {
  static const String id = "_id";
  static const String nrpuncte = "nrpuncte";
  static const String nume = "nume";
  static const String imageUrl = "imageUrl";
  static const String stadion = "stadion";
  static const String detinator = "detinator";
}

class UserFields {
  static const String id = "_id";
  static const String username = "username";
  static const String password = "password";
  static const String name = "name";
  static const String tip = "tip";
}

class MeciFields {
  static const String id = "_id";
  static const String Echipa1 = "echipa1";
  static const String Echipa2 = "echipa2";
  static const String goluri1 = "goluri1";
  static const String goluri2 = "goluri2";
}
