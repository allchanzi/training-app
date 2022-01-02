import 'package:fest_app/utilities/data_sources/exercise_data_source.dart';
import 'package:fest_app/utilities/data_sources/exercise_set_data_source.dart';
import 'package:fest_app/utilities/data_sources/session_data_source.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  static final db = DatabaseProvider();

  static final sessionProvider = SessionProvider();
  static final exerciseProvider = ExerciseProvider();
  static final exerciseSetProvider = ExerciseSetProvider();

  factory DatabaseProvider() {
    return _instance;
  }

  DatabaseProvider._internal();

  Future<Database> initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'main11.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE sessions ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "started DATETIME NULL, "
              "ended DATETIME NULL, "
              "type VARCHAR(1) NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE sets ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "started DATETIME NULL, "
              "ended DATETIME NULL, "
              "name VARCHAR(100) NOT NULL, "
              "weight REAL NOT NULL, "
              "number_of_sets INTEGER NOT NULL, "
              "repetitions INTEGER NOT NULL, "
              "pause INTEGER NULL,"
              "session_id INTEGER, "
              "FOREIGN KEY(session_id) REFERENCES sessions(id))",
        );
        await database.execute(
          "CREATE TABLE exercises ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "started DATETIME NULL, "
              "ended DATETIME NULL, "
              "repetitions INTEGER NOT NULL, "
              "pause INTEGER NULL, "
              "set_id INTEGER, "
              "type VARCHAR, " // TODO: make type entity in Db
              "FOREIGN KEY(set_id) REFERENCES sets(id))",
        );
      },
      version: 1,
    );
  }
}
