import 'package:flutter/material.dart';

class NoteTitleEntry extends StatelessWidget {
  final TextEditingController _textFieldController;

  const NoteTitleEntry(this._textFieldController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
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
            hintText: 'Title',
            hintStyle: TextStyle(
              fontSize: 21,
              height: 1.5,
              color: Colors.grey[600],
            ),
          ),
          maxLength: 32,
          maxLines: 1,
          style: TextStyle(
            fontSize: 20.5,
            height: 1.5,
            color: Colors.white.withOpacity(0.8),
          ),
          textCapitalization: TextCapitalization.words,
        ));
  }
}