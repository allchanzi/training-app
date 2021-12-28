import 'package:fest_app/models/exercise_set.dart';

import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseSetProvider {
  Future<void> insertExerciseSet(ExerciseSet exerciseSet) async {
    final db = await DatabaseProvider.db.initializeDB();

    await db.insert(
      'sets',
      exerciseSet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExerciseSet>> exerciseSets() async {
    final db = await DatabaseProvider.db.initializeDB();

    final List<Map<String, dynamic>> exerciseSetMaps = await db.query('sets');

    return List.generate(exerciseSetMaps.length, (i) {
      return ExerciseSet.fromMap(exerciseSetMaps[i]);
    });
  }


  Future<void> updateExerciseSet(ExerciseSet exerciseSet) async {
    final db = await DatabaseProvider.db.initializeDB();

    await db.update(
      'sets',
      exerciseSet.toMap(),
      where: 'id = ?',
      whereArgs: [exerciseSet.getId()],
    );
  }

  Future<void> deleteExerciseSet(int id) async {
    final db = await DatabaseProvider.db.initializeDB();

    await db.delete(
      'sets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<ExerciseSet?> getExerciseSetById(int id) async {
    final db = await DatabaseProvider.db.initializeDB();

    List<Map<String, dynamic>> exerciseSetMaps = await db.query(
      'sets',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (exerciseSetMaps.isNotEmpty && exerciseSetMaps.length == 1) {
      return ExerciseSet.fromMap(exerciseSetMaps[0]);
    }
  }

  Future<ExerciseSet?> getLastExerciseSet() async {
    final db = await DatabaseProvider.db.initializeDB();

    List<Map<String, dynamic>> exerciseSetMaps = await db
        .rawQuery("SELECT * FROM sets ORDER BY id DESC LIMIT 1;", []);
    if (exerciseSetMaps.isNotEmpty && exerciseSetMaps.length == 1) {
      return ExerciseSet.fromMap(exerciseSetMaps[0]);
    }
  }

  Future<List<ExerciseSet>> getExerciseSetsBySessionId(int sessionId) async {
    final db = await DatabaseProvider.db.initializeDB();

    print("AAAA");
    print(sessionId);

    List<Map<String, dynamic>> exerciseSetMaps = await db.query(
      'sets',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
    print(exerciseSetMaps);
    return List.generate(exerciseSetMaps.length, (i) {
      return ExerciseSet.fromMap(exerciseSetMaps[i]);
    });
  }
}
