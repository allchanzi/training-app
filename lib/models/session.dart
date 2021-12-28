class Session {
  int? id;
  final DateTime started;
  DateTime? ended;
  final String type;

  Session({
    this.id,
    required this.started,
    required this.ended,
    required this.type
  });

  Map<String, dynamic> toMap() {
    return {
      'started': started.toIso8601String(),
      'ended': ended?.toIso8601String(),
      'type': type,
    };
  }

  @override
  String toString() {
    return 'Session{id: $id, started: $started, ended: $ended, type: $type}';
  }

  static Session fromMap(Map<String, dynamic> map) {
    return Session(
      id: map["id"],
      started: DateTime.parse(map["started"]),
      ended: map["ended"] != null ? DateTime.parse(map["ended"]) : null,
      type: map["type"]
    );
  }

  int getId(){
    return id!;
  }

  String getSessionType() {
    return type;
  }

  void endSession() {
    ended=DateTime.now();
  }
}

