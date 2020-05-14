import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/screens/courses_screen.dart';

import '../constants.dart';

class MainDrawer extends StatefulWidget {
  final CoursesStore store;
  MainDrawer(this.store);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image(
                image: AssetImage("assets/app/logo.png"),

              ),
            ),
            ListTile(
              title: Text(
                "Subjects",
                style: TextStyle(fontSize: kDrawerItemSize),
              ),
              onTap: () {
/*Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SubjectScreen(widget.store, widget.course, widget.item)
              ))*/
              },
            ),
            ListTile(
              title: Text(
                "Subjects",
                style: TextStyle(fontSize: kDrawerItemSize),
              ),
              onTap: () {
/*Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SubjectScreen(widget.store, widget.course, widget.item)
              ))*/
              },
            ),
            ListTile(
              title: Text(
                "Subjects",
                style: TextStyle(fontSize: kDrawerItemSize),
              ),
              onTap: () {
/*Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SubjectScreen(widget.store, widget.course, widget.item)
              ))*/
              },
            ),
          ],
        ),
      ),
    );
  });
}
