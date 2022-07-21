import 'package:flutter/material.dart';
import 'package:notes/models/database/notes.dart';
import 'package:notes/screens/note_detail.dart';

Future<List<SavedNote>> readDatabase() async {
  try {
    MyDatabase notesDB = MyDatabase();
    DbQueries notesQuery = DbQueries(notesDB);
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
      MyDatabase notesDB = MyDatabase();
      DbQueries notesQuery = DbQueries(notesDB);
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
          title: const Text('Notes App'),
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
        body: FutureBuilder(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Material(
        elevation: 1,
        color: (selectedNote == false ? primaryColor : secondaryColor),
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
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (selectedNote == false
                              ? primaryColor
                              : secondaryColor),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('$notesData')),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        notesData.title,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 3,
                      ),
                      Text(
                        notesData.content,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
