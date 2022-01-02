import 'package:fest_app/models/exercise.dart';
import 'package:fest_app/models/exercise_set.dart';
import 'package:fest_app/models/session.dart';
import 'package:fest_app/utilities/services/database_provider.dart';

class ExerciseSetManager {
  static final ExerciseSetManager _instance = ExerciseSetManager._internal();

  static final manager = ExerciseSetManager();

  factory ExerciseSetManager() {
    return _instance;
  }

  ExerciseSetManager._internal();

  Future<ExerciseSet> getExerciseSet(String exerciseName, int numberOfSets,
      int repetitions, num weight, int pause, Session session) async {
    await DatabaseProvider.exerciseSetProvider.insertExerciseSet(ExerciseSet(
        started: DateTime.now(),
        name: exerciseName,
        weight: weight,
        numberOfSets: numberOfSets,
        repetitions: repetitions,
        pause: pause,
        sessionId: session.getId()));
    ExerciseSet? exerciseSet = await DatabaseProvider.exerciseSetProvider.getLastExerciseSet();
    List.generate(
        numberOfSets,
        (index) => DatabaseProvider.exerciseProvider.insertExercise(Exercise(
            type: exerciseName,
            repetitions: repetitions,
            pause: pause,
            setId: exerciseSet!.getId())));

    return exerciseSet!;
  }
}
