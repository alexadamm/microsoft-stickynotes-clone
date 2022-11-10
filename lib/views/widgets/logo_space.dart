import 'package:flutter/material.dart';

class LogoSpace extends StatelessWidget {
  const LogoSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                   Color.fromARGB(255, 230, 185, 4),
                   Color.fromARGB(255, 230, 185, 4)
                ]
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              )
            ),
            child:  Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/notes_icon.png', width: 50, height: 50,),
                  const Text(' Sticky Notes',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Color(0xFF202020)
                    )
                  ),
                ]),
          ),
    );
  }
}