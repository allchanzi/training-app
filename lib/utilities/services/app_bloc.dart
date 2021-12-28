import 'dart:async';

import 'package:fest_app/models/exercise.dart';
import 'package:fest_app/models/exercise_set.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:fest_app/models/session.dart';
import 'package:fest_app/utilities/services/session_manager.dart';

final appBloc = AppBloc();

enum AppEvent { onStart, onAppInitialized, onStop }

class AppBloc {
  final _appEventController = StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get appEventsStream => _appEventController.stream;

  dispatch(AppEvent event) {
    switch (event) {
      case AppEvent.onStart:
        _initializeApp();
        _sinkEvent(AppEvent.onStart);
        break;
      case AppEvent.onStop:
        _dispose();
        _sinkEvent(AppEvent.onStop);
        break;
      case AppEvent.onAppInitialized:
        _sinkEvent(AppEvent.onAppInitialized);
        break;
    }
  }

  void _sinkEvent(AppEvent appEvent) => _appEventController.sink.add(appEvent);

  _dispose() {
    _appEventController.close();
  }

  void _initializeApp() async {
    await DatabaseProvider.db.initializeDB();

    await _removeAllData();

    // SessionManager.manager.getNextSession(null);

    // print("HERE");
    // print(Session(started: DateTime.now(), ended: DateTime.now(), type: "A"));
    // DatabaseProvider.sessionProvider.insertSession(
    //     Session(started: DateTime.now(), ended: DateTime.now(), type: "A"));
    // DatabaseProvider.sessionProvider.insertSession(
    //     Session(started: DateTime.now(), ended: DateTime.now(), type: "B"));
    // print(await DatabaseProvider.sessionProvider.getSessionById(3));
    //
    // print(await DatabaseProvider.sessionProvider.sessions());
    //
    // print(ExerciseSet(
    //     started: DateTime.now(),
    //     ended: DateTime.now(),
    //     name: "Deadlift",
    //     weight: 90,
    //     numberOfSets: 6,
    //     repetitions: 4,
    //     pause: 90,
    //     sessionId: 1));
    // DatabaseProvider.exerciseSetProvider.insertExerciseSet(ExerciseSet(
    //     started: DateTime.now(),
    //     ended: DateTime.now(),
    //     name: "Deadlift",
    //     weight: 90,
    //     numberOfSets: 6,
    //     repetitions: 4,
    //     pause: 90,
    //     sessionId: 1));
    //
    // print(Exercise(
    //     started: DateTime.now(),
    //     ended: DateTime.now(),
    //     pause: 90,
    //     repetitions: 10,
    //     setId: 1));
    // DatabaseProvider.exerciseProvider.insertExercise(Exercise(
    //     started: DateTime.now(),
    //     ended: DateTime.now(),
    //     pause: 90,
    //     repetitions: 10,
    //     setId: 1));
    // print(await DatabaseProvider.exerciseProvider.getExerciseById(1));
    // Session? ses = await DatabaseProvider.sessionProvider.getLastSession();
    // ses!.endSession();
    // DatabaseProvider.sessionProvider.updateSession(ses);

    dispatch(AppEvent
        .onAppInitialized); // will execute when all initializations are complete,
  }

  Future<bool> _removeAllData() async {
    // For debugging purposes
    List<Exercise> exercises =
        await DatabaseProvider.exerciseProvider.exercises();
    List.generate(
        exercises.length,
        (index) => DatabaseProvider.exerciseProvider
            .deleteExercise(exercises[index].getId()));

    List<ExerciseSet> exerciseSets =
        await DatabaseProvider.exerciseSetProvider.exerciseSets();
    List.generate(
        exerciseSets.length,
        (index) => DatabaseProvider.exerciseSetProvider
            .deleteExerciseSet(exerciseSets[index].getId()));

    List<Session> sessions = await DatabaseProvider.sessionProvider.sessions();
    List.generate(
        sessions.length,
        (index) => DatabaseProvider.sessionProvider
            .deleteSession(sessions[index].getId()));
    return true;
  }
}
