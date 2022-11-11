import 'package:flutter/material.dart';
import 'package:sticky_notes_clone/models/add_note_request.dart';
import 'package:sticky_notes_clone/models/note_response.dart';
import 'package:sticky_notes_clone/services/api_service.dart';
import 'package:sticky_notes_clone/views/widgets/note_content_entry.dart';
import 'package:sticky_notes_clone/views/widgets/note_title_entry.dart';

class NoteDetailPage extends StatefulWidget {
  final List args;
  const NoteDetailPage(this.args, {super.key});

  @override
  _NoteDetailPage createState() => _NoteDetailPage();
}

class _NoteDetailPage extends State<NoteDetailPage> {
  final primaryColor = const Color(0xFF202020);

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

  Future<void> handleBackButton() async {
    if (title.isEmpty) {
      // Go back without saving
      if (content.isEmpty) {
        Navigator.pop(context);
        return;
      }
      setState(() {
        title = 'Untitled';
      });
    }

    if (content.isEmpty) {
      setState(() {
        content = ' ';
      });
    }

    // Save new note
    if (widget.args[0] == 'new') {
      AddNoteRequest note = AddNoteRequest(title: title, content: content);

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
      AddNoteRequest note = AddNoteRequest(
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

  Future<NoteResponseModel> _insertNote(AddNoteRequest note) async {
    return await APIService.addNote(note);
  }

  Future<NoteResponseModel?> _updateNote(AddNoteRequest note) async {
    NoteResponseModel oldNote = await APIService.getNoteById(note.id!);
    if (note.title == oldNote.data!.note!.title &&
        note.content == oldNote.data!.note!.content) {
      return null;
    }
    return await APIService.updateNoteById(note.id!, note);
  }

  @override
  void initState() {
    super.initState();
    title = (widget.args[0] == 'new' ? '' : widget.args[1].title);
    content = (widget.args[0] == 'new' ? '' : widget.args[1].content);

    _titleTextController.text =
        (widget.args[0] == 'new' || widget.args[1].title == 'Untitled'
            ? ''
            : widget.args[1].title);
    _contentTextController.text =
        ((widget.args[0] == 'new' || widget.args[1].content == ' ')
            ? ''
            : widget.args[1].content);
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
          await handleBackButton();
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
