class ExerciseSet {
  int? id;
  final DateTime started;
  DateTime? ended;
  final String name;
  final num weight;
  final int numberOfSets;
  final int repetitions;
  final int pause;
  final int sessionId;

  ExerciseSet({
    this.id,
    required this.started,
    this.ended,
    required this.name,
    required this.weight,
    required this.numberOfSets,
    required this.repetitions,
    required this.pause,
    required this.sessionId
  });

  Map<String, dynamic> toMap() {
    return {
      'started': started.toIso8601String(),
      'ended': ended?.toIso8601String(),
      'name': name,
      'weight': weight,
      'number_of_sets': numberOfSets,
      'repetitions': repetitions,
      'pause': pause,
      'session_id': sessionId
    };
  }

  @override
  String toString() {
    return 'ExerciseSet{id: $id, started: $started, ended: $ended, session: $sessionId}';
  }

  static ExerciseSet fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
        id: map["id"],
        started: DateTime.parse(map["started"]),
        ended: map["ended"] != null ? DateTime.parse(map["ended"]) : null,
        name: map["name"],
        weight: map["weight"],
        numberOfSets: map["number_of_sets"],
        repetitions: map["repetitions"],
        pause: map["pause"],
        sessionId: map["session_id"]
    );
  }

  int getId() {
    return id!;
  }

  void endSet() {
    ended=DateTime.now();
  }
}

