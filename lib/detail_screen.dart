import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return const DetailMobilePage();
    });
  }
}

class DetailMobilePage extends StatelessWidget {
  final primaryColor = const Color.fromARGB(255, 51, 51, 51);
  const DetailMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_back_ios_new, color: primaryColor),
              Icon(Icons.settings, color: primaryColor),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 230, 185, 4),
        ));
  }
}
