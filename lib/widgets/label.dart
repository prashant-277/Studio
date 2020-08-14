import 'package:flutter/widgets.dart';

class Label extends StatelessWidget {

  final String text;
  final EdgeInsets padding;

  Label({ @required this.text, this.padding });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Text(this.text,
        style: TextStyle(
            fontSize: 14
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
