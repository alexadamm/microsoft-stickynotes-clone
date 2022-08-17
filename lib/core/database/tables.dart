import 'package:drift/drift.dart';

@DataClassName('SavedNote')
class SavedNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
}
