import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/widgets/course_title.dart';

import '../../constants.dart';

class TestHomeScreen extends StatefulWidget {

  final String id = "test_home_screen";
  final CoursesStore store;

  TestHomeScreen(this.store);

  @override
  _TestHomeScreenState createState() => _TestHomeScreenState();
}

class _TestHomeScreenState extends State<TestHomeScreen> {

  @override
  void initState() {
    widget.store.loadQuestions(courseId: widget.store.course.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
    print("TestHomeScreen");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: kDarkBlue),
        title: CourseTitle(widget.store, widget.store.course, kContrastDarkColor),
        backgroundColor: kLightGrey,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text("Wait...")
          ],
        )
      ),
    );
  });
}
