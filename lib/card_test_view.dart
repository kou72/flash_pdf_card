import 'package:flutter/material.dart';

class CardTestView extends StatefulWidget {
  const CardTestView({Key? key}) : super(key: key);
  @override
  CardTestViewState createState() => CardTestViewState();
}

class CardTestViewState extends State<CardTestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('test'),
    );
  }
}