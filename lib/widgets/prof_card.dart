import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfCard extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final List<Widget> buttons;

  ProfCard({@required this.text, this.fontWeight, this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 10, 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 16,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10
          ),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                left: -40,
                top: -20,
                child: Image(
                  image: AssetImage("assets/images/prof.png"),
                  height: 160,
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 80,
                    height: 100,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            this.text,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: this.fontWeight,
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: buttons,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
