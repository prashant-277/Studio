import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/colors.dart';
import 'package:studio/models/course.dart';
import 'package:studio/screens/course/course.dart';
import 'package:studio/screens/home/fresh_start.dart';
import 'package:studio/services/professor_service.dart';
import 'package:studio/widgets/drawer.dart';
import 'package:studio/widgets/label.dart';

import '../../auth_store.dart';
import '../../courses_store.dart';
import '../../globals.dart';
import '../edit_course.dart';
import 'professor_home.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProfessorAdviceResult advice;

  @override
  void initState() {
    super.initState();
    Globals.coursesStore.loadCourses();
    Globals.authStore.loadStats();
  }

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        print("build home");
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            title: Text('Study Hero'),
            centerTitle: true,
            backgroundColor: kBackgroundColor,
          ),
          drawer: MainDrawer(),
          floatingActionButton: _getFAB(),
          body: SingleChildScrollView(
            child: Container(
              color: kBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: homeWidgets(),
                ),
              ),
            ),
          ),
        );
      });

  SpeedDial _getFAB() {
    if (Globals.coursesStore.courses.length > 0) {
      return SpeedDial(
        child: Icon(LineAwesomeIcons.plus),
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
              child: Icon(LineAwesomeIcons.chalkboard_teacher),
              label: 'Add course',
              labelStyle: TextStyle(fontSize: 14.0),
              onTap: () {
                Navigator.pushNamed(context, EditCourseScreen.id);
              }),
          SpeedDialChild(
              child: Icon(LineAwesomeIcons.book_open),
              label: 'Add subject',
              labelStyle: TextStyle(fontSize: 14.0),
              onTap: () => print('FIRST CHILD')),
          SpeedDialChild(
              child: Icon(LineAwesomeIcons.marker),
              label: 'Add key concept',
              labelStyle: TextStyle(fontSize: 14.0),
              onTap: () => print('FIRST CHILD')),
        ],
      );
    }

    return null;
  }

  List<Widget> homeWidgets() {
    var list = List<Widget>();

    if (Globals.coursesStore.isCoursesLoading) {
      list.add(LinearProgressIndicator());
    }

    list.add(ProfessorHome());

    if (Globals.coursesStore.courses.length > 0) {
      list.add(
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
            child: Label(text: 'Your courses'),
          ),
        ),
      );
    }

    list.add(
      Column(
        children: Globals.coursesStore.courses
            .map(
              (course) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(course.name),
                    leading: Image(
                      image: AssetImage("assets/icons/${course.icon}"),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      if (Globals.coursesStore.course != course)
                        Globals.coursesStore.subjects.clear();

                      Globals.coursesStore.course = course;
                      Navigator.pushNamed(context, CourseScreen.id);
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );

    return list;
  }
}
