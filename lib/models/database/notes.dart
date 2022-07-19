import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../note.dart';

part 'notes.g.dart';

@DataClassName('SavedNote')
class SavedNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
}

@DriftDatabase(tables: [SavedNotes])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notes.db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftAccessor(tables: [SavedNotes])
class DbQueries extends DatabaseAccessor<MyDatabase> with _$DbQueriesMixin {
  DbQueries(MyDatabase db) : super(db);

  Future<int> insertNote(Note note) async {
    return await into(savedNotes).insert(
      SavedNotesCompanion(
          title: Value(note.title), content: Value(note.content)),
    );
  }

  Future<int> updateNoteById(Note note) async {
    return await (update(savedNotes)..where((t) => t.id.equals(note.id))).write(
      SavedNotesCompanion(
          title: Value(note.title), content: Value(note.content)),
    );
  }

  Future<List<SavedNote>> getAllNotes() async {
    return await (select(savedNotes)
          ..orderBy([(t) => OrderingTerm(expression: t.title)]))
        .get();
  }

  Future<List<SavedNote>> getNoteById(int id) async {
    return await (select(savedNotes)..where((t) => t.id.equals(id))).get();
  }

  Future<int> deleteNoteById(int id) async {
    return await (delete(savedNotes)..where((t) => t.id.equals(id))).go();
  }
}
