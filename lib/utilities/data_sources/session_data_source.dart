import '../../models/session.dart';

import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fest_app/models/session.dart';

class SessionProvider {
  Future<void> insertSession(Session session) async {
    final db = await DatabaseProvider.db.initializeDB();

    await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Session>> sessions() async {
    final db = await DatabaseProvider.db.initializeDB();

    final List<Map<String, dynamic>> sessionMaps = await db.query('sessions', orderBy: "id DESC");

    return List.generate(sessionMaps.length, (i) {
      return Session.fromMap(sessionMaps[i]);
    });
  }

  Future<List<Session>> getSessionsByType(String? type) async {
    final db = await DatabaseProvider.db.initializeDB();
    if (type == null) {
      return sessions();
    }

    final List<Map<String, dynamic>> sessionMaps =
        await db.query('sessions', where: "type = ?", whereArgs: [type]);

    return List.generate(sessionMaps.length, (i) {
      return Session.fromMap(sessionMaps[i]);
    });
  }

  Future<void> updateSession(Session session) async {
    final db = await DatabaseProvider.db.initializeDB();

    await db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.getId()],
    );
  }

  Future<void> deleteSession(int id) async {
    final db = await DatabaseProvider.db.initializeDB();

    await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Session?> getSessionById(int id) async {
    final db = await DatabaseProvider.db.initializeDB();

    List<Map<String, dynamic>> sessionMaps = await db.query(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (sessionMaps.isNotEmpty && sessionMaps.length == 1) {
      return Session.fromMap(sessionMaps[0]);
    }
  }

  Future<Session?> getLastSession() async {
    final db = await DatabaseProvider.db.initializeDB();

    List<Map<String, dynamic>> sessionMaps = await db
        .rawQuery("SELECT * FROM sessions ORDER BY id DESC LIMIT 1;", []);
    if (sessionMaps.isNotEmpty && sessionMaps.length == 1) {
      return Session.fromMap(sessionMaps[0]);
    }
  }
}
