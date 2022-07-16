import 'package:flutter/material.dart';
import 'package:notes/screens/note_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final primaryColor = const Color(0xFF202020);
  final secondaryColor = const Color.fromARGB(255, 230, 185, 4);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Note',
      home: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
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
              MaterialPageRoute(builder: ((context) => const NoteDetail())),
            )
          },
          child: Icon(Icons.add, color: primaryColor),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
