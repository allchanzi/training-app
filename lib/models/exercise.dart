class Exercise {
  int? id;
  DateTime? started;
  DateTime? ended;
  late final int repetitions;
  late int? pause;
  final int setId;

  Exercise(
      {this.id,
      this.started,
      this.ended,
      this.pause,
      required this.repetitions,
      required this.setId});

  Map<String, dynamic> toMap() {
    return {
      'started': started?.toIso8601String(),
      'ended': ended?.toIso8601String(),
      'repetitions': repetitions,
      'pause': pause,
      'set_id': setId
    };
  }

  @override
  String toString() {
    return 'Exercise{'
        'id: $id, '
        'started: $started, '
        'ended: $ended, '
        'repetitions: $repetitions, '
        'pause: $pause}';
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
        id: map["id"],
        started: map["started"] != null ? DateTime.parse(map["started"]) : null,
        ended: map["ended"] != null ? DateTime.parse(map["ended"]) : null,
        repetitions: map["repetitions"],
        pause: map["pause"],
        setId: map["set_id"]);
  }

  int getId() {
    return id!;
  }

  void endExercise() {
    ended = DateTime.now();
  }

  void startExercise() {
    started = DateTime.now();
  }

  void setPause(int _pause) {
    pause = _pause;
  }
}
