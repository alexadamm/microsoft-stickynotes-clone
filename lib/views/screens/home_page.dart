import 'package:flutter/material.dart';
import 'package:sticky_notes_clone/models/note_detail_model.dart';
import 'package:sticky_notes_clone/models/notes_response_model.dart';
import 'package:sticky_notes_clone/views/screens/note_detail_page.dart';
import 'package:sticky_notes_clone/services/api_service.dart';
import 'package:sticky_notes_clone/services/shared_services.dart';

import '../../utils/last_update.dart';

Future<List<NoteDetailModel>> readDatabase() async {
  try {
    NotesResponseModel notesResponse = await APIService.getAllNotes();
    List<NoteDetailModel> notesList = notesResponse.data!.notes;
    return notesList;
  } catch (e) {
    throw Error();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final primaryColor = const Color(0xFF202020);
  final secondaryColor = const Color.fromARGB(255, 230, 185, 4);

  List<NoteDetailModel>? notesData = [];
  List<String> selectedNoteIds = [];

  // Render the screen and update changes
  void afterNavigatorPop() {
    setState(() {});
  }

  // Long Press handler to display bottom bar
  void handleNoteListLongPress(String id) {
    setState(() {
      if (selectedNoteIds.contains(id) == false) {
        selectedNoteIds.add(id);
      }
    });
  }

  // Remove selection after long press
  void handleNoteListTapAfterSelect(String id) {
    setState(() {
      if (selectedNoteIds.contains(id) == true) {
        selectedNoteIds.remove(id);
      }
    });
  }

  // Delete Note/Notes
  void handleDelete() async {
    try {
      for (String id in selectedNoteIds) {
        await APIService.deleteNoteById(id);
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
    bool isAPIcallProcess = false;
    return MaterialApp(
      title: 'Sticky Notes',
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
                : IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: secondaryColor,
                    ),
                    tooltip: 'Logout',
                    onPressed: () async {
                      await SharedService.logout(context);
                    }))
          ],
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: Row(children: [
            Image.asset(
              'assets/images/notes_icon.png',
              width: 40,
            ),
            const Text(' Sticky Notes',
                style: TextStyle(
                  color: Color.fromARGB(255, 230, 185, 4),
                )),
          ]),
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
                  builder: (context) => const NoteDetailPage(['new', {}])),
            ).then((dynamic value) => afterNavigatorPop())
          },
          child: Icon(Icons.add, color: primaryColor),
        ),
        body: FutureBuilder<List<NoteDetailModel>>(
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
  final List<NoteDetailModel> data;
  final List<String> selectedNoteIds;
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
          NoteDetailModel item = data[index];
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

  final NoteDetailModel notesData;
  final List<String> selectedNoteIds;
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
    String lastUpdate = LastUpdate(
            updatedAt:
                DateTime.parse(notesData.updatedAt).millisecondsSinceEpoch)
        .whenUpdatedAt();
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
                      builder: (context) =>
                          NoteDetailPage(['update', notesData]),
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
