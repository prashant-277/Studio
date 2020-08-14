import 'package:flutter/widgets.dart';

class MiniSubtitle extends StatelessWidget {
  final String text;

  MiniSubtitle({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
