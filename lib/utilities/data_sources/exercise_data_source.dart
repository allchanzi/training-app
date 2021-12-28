import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fest_app/models/exercise.dart';

class ExerciseProvider {
  Future<void> insertExercise(Exercise exercise) async {
    final db = await DatabaseProvider.db.initializeDB();

    await db.insert(
      'exercises',
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Exercise>> exercises() async {
    final db = await DatabaseProvider.db.initializeDB();

    final List<Map<String, dynamic>> exerciseMaps = await db.query('exercises');

    return List.generate(exerciseMaps.length, (i) {
      return Exercise.fromMap(exerciseMaps[i]);
    });
  }

  Future<void> updateExercise(Exercise exercise) async {
    final db = await DatabaseProvider.db.initializeDB();

    await db.update(
      'exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.getId()],
    );
  }

  Future<void> deleteExercise(int id) async {
    final db = await DatabaseProvider.db.initializeDB();

    await db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Exercise?> getExerciseById(int id) async {
    final db = await DatabaseProvider.db.initializeDB();

    List<Map<String, dynamic>> exerciseMaps = await db.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (exerciseMaps.isNotEmpty && exerciseMaps.length == 1) {
      return Exercise.fromMap(exerciseMaps[0]);
    }
  }

  Future<List<Exercise>> getExerciseByExerciseSetId(int exerciseSetId) async {
    final db = await DatabaseProvider.db.initializeDB();

    List<Map<String, dynamic>> exerciseMaps = await db.query(
      'exercises',
      where: 'set_id = ?',
      whereArgs: [exerciseSetId],
    );
    return List.generate(
        exerciseMaps.length, (index) => Exercise.fromMap(exerciseMaps[index]));
  }
}
