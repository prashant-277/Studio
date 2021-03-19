import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';

class WhiteButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  WhiteButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.white,
      textColor: kDarkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  PrimaryButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: kPrimaryColor,
      textColor: kDarkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
    );
  }
}