import 'package:flutter/widgets.dart';

class Subtitle extends StatelessWidget {

  final String text;

  Subtitle({ @required this.text });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
