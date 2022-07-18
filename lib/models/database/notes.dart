import 'package:sqflite/sqflite.dart';

import '../note.dart';

class NotesDatabase {
  final _name = "NotesDatabase.db";
  final _version = 1;

  late Database database;
  final tableName = 'notes';

  initDatabase() async {
    database = await openDatabase(_name, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT,
            content TEXT)''');
    });
  }

  Future<int> insertNote(Note note) async {
    return await database.insert(tableName, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateNoteById(Note note) async {
    return await database.update(tableName, note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    return await database.query(tableName);
  }

  Future<Map<String, dynamic>?> getNoteById(int id) async {
    var result =
        await database.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<int> deleteNoteById(int id) async {
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  closeDatabase() async {
    await database.close();
  }
}
