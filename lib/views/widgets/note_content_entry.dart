
import 'package:flutter/material.dart';

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
          cursorColor: const Color.fromARGB(255, 230, 185, 4),
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
            hintText: 'Take a note...',
            hintStyle: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[600],
            ),
          ),
          maxLines: null,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Colors.white.withOpacity(0.8),
          ),
          textCapitalization: TextCapitalization.sentences,
        ));
  }
}
