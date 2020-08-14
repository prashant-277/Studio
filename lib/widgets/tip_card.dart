import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {

  final String text;

  TipCard({ @required this.text });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 12
      ),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(this.text),
        ),
      ),
    );
  }
}
