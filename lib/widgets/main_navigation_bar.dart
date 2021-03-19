import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../constants.dart';

enum HighlightedTab {
  Courses, Purchase, Tests, Stats
}

class MainNavigationBar extends StatelessWidget {
  final HighlightedTab tab;

  MainNavigationBar(this.tab);

  @override
  Widget build(BuildContext context) {

    Map<HighlightedTab, int> alpha = Map();
    alpha[HighlightedTab.Courses] = tab == HighlightedTab.Courses ? 255:100;
    alpha[HighlightedTab.Purchase] = tab == HighlightedTab.Purchase ? 255:100;
    alpha[HighlightedTab.Tests] = tab == HighlightedTab.Tests ? 255:100;
    alpha[HighlightedTab.Stats] = tab == HighlightedTab.Stats ? 255:100;

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Icon(
                LineAwesomeIcons.book,
                color: Colors.white.withAlpha(alpha[HighlightedTab.Courses]),
              ),
              onPressed: () {

              },
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Icon(
                LineAwesomeIcons.rocket,
                color: Colors.white.withAlpha(alpha[HighlightedTab.Purchase]),
              ),
              onPressed: () {
              },
            ),
          ),
          Expanded(
            child: FlatButton(

            ),
          ),
          Expanded(
            child: FlatButton(
              child: Icon(
                LineAwesomeIcons.graduation_cap,
                color: Colors.white.withAlpha(alpha[HighlightedTab.Tests]),
              ),
              onPressed: () {

              },
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Icon(
                LineAwesomeIcons.chart_line,
                color: Colors.white.withAlpha(alpha[HighlightedTab.Stats]),
              ),
              onPressed: () {

              },
            ),
          ),
        ],
      ),
      shape: CircularNotchedRectangle(),
      color: kDarkGrey,
      elevation: 10,
    );
  }
}
