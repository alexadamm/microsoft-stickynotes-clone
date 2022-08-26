import 'package:flutter/material.dart';
import 'package:notes/core/container.dart';
import 'package:notes/screens/note_detail.dart';

import '../core/database/notes.dart';
import '../utils/last_update.dart';

Future<List<SavedNote>> readDatabase() async {
  try {
    List<SavedNote> notesList = await notesQuery.getAllNotes();
    return notesList;
  } catch (e) {
    throw Error();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final primaryColor = const Color(0xFF202020);
  final secondaryColor = const Color.fromARGB(255, 230, 185, 4);

  List<SavedNote>? notesData = [];
  List<int> selectedNoteIds = [];

  // Render the screen and update changes
  void afterNavigatorPop() {
    setState(() {});
  }

  // Long Press handler to display bottom bar
  void handleNoteListLongPress(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == false) {
        selectedNoteIds.add(id);
      }
    });
  }

  // Remove selection after long press
  void handleNoteListTapAfterSelect(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == true) {
        selectedNoteIds.remove(id);
      }
    });
  }

  // Delete Note/Notes
  void handleDelete() async {
    try {
      for (int id in selectedNoteIds) {
        await notesQuery.deleteNoteById(id);
      }
    } catch (e) {
      throw Error();
    } finally {
      setState(() {
        selectedNoteIds = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Note',
      home: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          actions: [
            (selectedNoteIds.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: secondaryColor,
                    ),
                    tooltip: 'Delete',
                    onPressed: () => handleDelete())
                : Container()),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: const Text('Notes App',
              style: TextStyle(
                color: Color.fromARGB(255, 230, 185, 4),
              )),
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          tooltip: 'Add Notes',
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NoteDetail(['new', {}])),
            ).then((dynamic value) => afterNavigatorPop())
          },
          child: Icon(Icons.add, color: primaryColor),
        ),
        body: FutureBuilder<List<SavedNote>>(
            future: readDatabase(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                notesData = snapshot.data;
                return Stack(
                  children: <Widget>[
                    // Display Notes
                    AllNoteLists(
                      snapshot.data!,
                      selectedNoteIds,
                      afterNavigatorPop,
                      handleNoteListLongPress,
                      handleNoteListTapAfterSelect,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text('Error reading database');
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                    backgroundColor: primaryColor,
                  ),
                );
              }
            }),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Display all notes
class AllNoteLists extends StatelessWidget {
  final List<SavedNote> data;
  final List<int> selectedNoteIds;
  final VoidCallback afterNavigatorPop;
  final handleNoteListLongPress;
  final handleNoteListTapAfterSelect;

  const AllNoteLists(this.data, this.selectedNoteIds, this.afterNavigatorPop,
      this.handleNoteListLongPress, this.handleNoteListTapAfterSelect,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          SavedNote item = data[index];
          return DisplayNotes(
            item,
            selectedNoteIds,
            (selectedNoteIds.contains(item.id) == false ? false : true),
            afterNavigatorPop,
            handleNoteListLongPress,
            handleNoteListTapAfterSelect,
          );
        });
  }
}

class DisplayNotes extends StatelessWidget {
  final primaryColor = const Color(0xFF202020);
  final secondaryColor = const Color.fromARGB(255, 230, 185, 4);
  final tertiaryColor = const Color.fromARGB(255, 51, 51, 51);

  final SavedNote notesData;
  final List<int> selectedNoteIds;
  final bool selectedNote;
  final VoidCallback callAfterNavigatorPop;
  final handleNoteListLongPress;
  final handleNoteListTapAfterSelect;

  const DisplayNotes(
      this.notesData,
      this.selectedNoteIds,
      this.selectedNote,
      this.callAfterNavigatorPop,
      this.handleNoteListLongPress,
      this.handleNoteListTapAfterSelect,
      {super.key});

  @override
  Widget build(BuildContext context) {
    String lastUpdate =
        LastUpdate(updatedAt: notesData.updatedAt).whenUpdatedAt();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Material(
          elevation: 4,
          color: (selectedNote == false ? tertiaryColor : secondaryColor),
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(5.0),
          child: InkWell(
            onTap: () {
              if (selectedNote == false) {
                if (selectedNoteIds.isEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetail(['update', notesData]),
                    ),
                  ).then((dynamic value) => callAfterNavigatorPop());
                  return;
                } else {
                  handleNoteListLongPress(notesData.id);
                }
              } else {
                handleNoteListTapAfterSelect(notesData.id);
              }
            },
            onLongPress: () {
              handleNoteListLongPress(notesData.id);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    top: (selectedNote == false
                        ? BorderSide(width: 3, color: secondaryColor)
                        : BorderSide(color: tertiaryColor))),
              ),
              child: Card(
                color: (selectedNote == false
                    ? Colors.transparent
                    : tertiaryColor),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notesData.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            lastUpdate,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 3,
                      ),
                      Text(
                        notesData.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
