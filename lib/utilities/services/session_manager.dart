import 'package:fest_app/models/session.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:fest_app/utilities/services/exercise_set_manager.dart';

class SessionManager {
  static final Map<String, String> NEXT_SESSION = {
    "A": "B",
    "B": "C",
    "C": "D",
    "D": "A"
  };

  static final SessionManager _instance = SessionManager._internal();

  static final manager = SessionManager();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  void _generateSessionA(Session session) async {
    await ExerciseSetManager.manager.getExerciseSet("Squat", 6, 4, 20, 160, session);
    await ExerciseSetManager.manager.getExerciseSet("Shoulder Press", 4, 8, 10, 120, session);
    await ExerciseSetManager.manager.getExerciseSet("Single Arm Lateral Raise", 4, 10, 5, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Standing Bent Over Lateral Raises", 4, 12, 20, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Cable Kneeling Crunches", 4, 15, 0, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Standing Calf Raises", 4, 10, 30, 60, session);
  }

  void _generateSessionB(Session session) async {
    await ExerciseSetManager.manager.getExerciseSet("Deadlift", 6, 4, 30, 160, session);
    await ExerciseSetManager.manager.getExerciseSet("Pull Up", 4, 5, 0, 120, session);
    await ExerciseSetManager.manager.getExerciseSet("Dumbbell Incline Press", 4, 8, 5, 120, session);
    await ExerciseSetManager.manager.getExerciseSet("Dumbbell Flies", 4, 10, 5, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Cable Biceps Curl", 4, 12, 10, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Cable Triceps Pushdown", 4, 12, 10, 60, session);
  }

  void _generateSessionC(Session session) async {
    await ExerciseSetManager.manager.getExerciseSet("Front Squat", 4, 8, 20, 160, session);
    await ExerciseSetManager.manager.getExerciseSet("Belt Squat", 4, 10, 10, 120, session);
    await ExerciseSetManager.manager.getExerciseSet("Military Press", 4, 6, 20, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Lateral Raise", 4, 8, 5, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Pull Up Bar Leg Raises", 4, 20, 0, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Sitting Calf Raises", 4, 12, 30, 60, session);
  }

  void _generateSessionD(Session session) async {
    await ExerciseSetManager.manager.getExerciseSet("Benchpress", 6, 4, 20, 160, session);
    await ExerciseSetManager.manager.getExerciseSet("Bent Over Row", 4, 8, 20, 120, session);
    await ExerciseSetManager.manager.getExerciseSet("Lat Pulldown", 4, 10, 20, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Dumbbell Biceps Curl", 4, 8, 5, 60, session);
    await ExerciseSetManager.manager.getExerciseSet("Barbell French Press", 4, 8, 10, 60, session);
   }

  void _generateSetsForSession(Session session) {
    print(session.type);
    String sessionType = session.type;
    switch (sessionType) {
      case ("A"): _generateSessionA(session); break;
      case ("B"): _generateSessionB(session); break;
      case ("C"): _generateSessionC(session); break;
      case ("D"): _generateSessionD(session); break;
    }
  }

  Future<Session> getNextSession(Session? lastSession) async {
    Session session;
    String sessionType = "A";
    if (lastSession == null) {
      // Create first session
      session = Session(id: 0,
          started: DateTime.now(),
          ended: null,
          type: sessionType);
      DatabaseProvider.sessionProvider.insertSession(session);
    } else {
    sessionType = NEXT_SESSION[lastSession.type]!;
    session = Session(
        started: DateTime.now(),
        ended: null,
        type: sessionType);
    DatabaseProvider.sessionProvider.insertSession(session);
    }
    session = await DatabaseProvider.sessionProvider.getLastSession() as Session;
    print(session);
    _generateSetsForSession(session);

    return session;
  }
}
