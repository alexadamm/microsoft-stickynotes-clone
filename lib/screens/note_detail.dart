import 'package:flutter/material.dart';

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
    );
  }
}

class NoteTitleEntry extends StatelessWidget {
  final _textFieldController;

  const NoteTitleEntry(this._textFieldController);

  @override
  Widget build(BuildContext context) {
    return TextField();
  }
}
