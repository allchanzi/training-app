class Exercise {
  String type;
  int? id;
  DateTime? started;
  DateTime? ended;
  late int repetitions;
  late int? pause;
  final int setId;

  Exercise(
      {required this.type,
        this.id,
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
      'set_id': setId,
      'type': type
    };
  }

  @override
  String toString() {
    return 'Exercise{'
        'type: $type, '
        'id: $id, '
        'started: $started, '
        'ended: $ended, '
        'repetitions: $repetitions, '
        'pause: $pause}';
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
        type: map["type"],
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

  void setRepetitions(int _repetitions) {
    repetitions = _repetitions;
  }
}
