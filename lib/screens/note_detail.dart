import 'package:flutter/material.dart';
import 'package:notes/models/database/notes.dart';
import 'package:notes/models/note.dart';

class NoteDetail extends StatefulWidget {
  const NoteDetail({super.key});

  @override
  _NoteDetail createState() => _NoteDetail();
}

class _NoteDetail extends State<NoteDetail> {
  final primaryColor = const Color.fromARGB(255, 51, 51, 51);

  String title = '';
  String content = '';

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _contentTextController = TextEditingController();

  void handleTitleTextChange() {
    setState(() {
      title = _titleTextController.text.trim();
    });
  }

  void handleContentTextChange() {
    setState(() {
      title = _contentTextController.text.trim();
    });
  }

  void handleBackButton() async {
    if (title.isEmpty) {
      // Go back without saving
      if (content.isEmpty) {
        Navigator.pop(context);
        return;
      }

      // Set content as title
      String trimmedContent = content.split('\n')[0];
      if (trimmedContent.length > 32) {
        trimmedContent = trimmedContent.substring(0, 32);
        setState(() {
          title = trimmedContent;
        });
      }
    }

    // Save new note
    Note note = Note(title: title, content: content);
    try {
      await _insertNote(note);
    } catch (e) {
      print('Error inserting note');
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> _insertNote(Note note) async {
    NotesDatabase notesDB = new NotesDatabase();
    await notesDB.initDatabase();
    int result = await notesDB.insertNote(note);
    await notesDB.closeDatabase();
  }

  @override
  void initState() {
    super.initState();
    _titleTextController.addListener(handleTitleTextChange);
    _contentTextController.addListener(handleContentTextChange);
  }

  @override
  void dispose() {
    super.dispose();
    _titleTextController.dispose();
    _contentTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Icon(Icons.settings, color: primaryColor),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 230, 185, 4),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                NoteTitleEntry(_titleTextController),
                NoteContentEntry(_contentTextController),
              ],
            ),
          ),
        ));
  }
}

class NoteTitleEntry extends StatelessWidget {
  final _textFieldController;

  const NoteTitleEntry(this._textFieldController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        child: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.all(0),
            counter: null,
            counterText: "",
            hintText: 'Title',
            hintStyle: TextStyle(
              fontSize: 21,
              height: 1.5,
              color: Colors.grey[600],
            ),
          ),
          maxLength: 32,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 20.5,
            height: 1.5,
            color: Colors.white,
          ),
          textCapitalization: TextCapitalization.words,
        ));
  }
}

class NoteContentEntry extends StatelessWidget {
  final _textFieldController;

  const NoteContentEntry(this._textFieldController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.all(0),
            counter: null,
            counterText: "",
            hintText: 'Note',
            hintStyle: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[600],
            ),
          ),
          maxLines: null,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Colors.white,
          ),
          textCapitalization: TextCapitalization.sentences,
        ));
  }
}
