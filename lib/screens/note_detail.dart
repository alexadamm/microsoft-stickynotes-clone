import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/database/notes.dart';

class NoteDetail extends StatefulWidget {
  final List args;
  const NoteDetail(this.args, {super.key});

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
      content = _contentTextController.text.trim();
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
      }
      setState(() {
        title = trimmedContent;
      });
    }

    // Save new note
    if (widget.args[0] == 'new') {
      Note note = Note(title: title, content: content);

      try {
        await _insertNote(note);
      } catch (e) {
        throw Error();
      } finally {
        Navigator.pop(context);
      }
    }

    // Update note
    else if (widget.args[0] == 'update') {
      Note note = Note(
        id: widget.args[1].id,
        title: title,
        content: content,
      );

      try {
        await _updateNote(note);
      } catch (e) {
        throw Error();
      } finally {
        Navigator.pop(context);
      }
    }
  }

  Future<int> _insertNote(Note note) async {
    MyDatabase notesDB = MyDatabase();
    DbQueries notesQuery = DbQueries(notesDB);
    return await notesQuery.insertNote(note);
  }

  Future<int> _updateNote(Note note) async {
    MyDatabase notesDB = MyDatabase();
    DbQueries notesQuery = DbQueries(notesDB);
    return await notesQuery.updateNoteById(note);
  }

  @override
  void initState() {
    super.initState();
    title = (widget.args[0] == 'new' ? '' : widget.args[1].title);
    content = (widget.args[0] == 'new' ? '' : widget.args[1].content);

    _titleTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1].title);
    _contentTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1].content);
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
    return WillPopScope(
        onWillPop: () async {
          handleBackButton();
          return true;
        },
        child: Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
                tooltip: 'Back',
                onPressed: handleBackButton,
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
            )));
  }
}

class NoteTitleEntry extends StatelessWidget {
  final TextEditingController _textFieldController;

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
  final TextEditingController _textFieldController;

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
