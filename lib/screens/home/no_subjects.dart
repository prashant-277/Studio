import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studio/globals.dart';
import 'package:studio/models/course_stats.dart';
import 'package:studio/screens/edit_subject.dart';
import 'package:studio/widgets/prof_card.dart';

import '../../colors.dart';

class NoSubjectScreen extends StatelessWidget {
  final CourseStats course;

  NoSubjectScreen(this.course);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ProfCard(
          text: "${course.name} has no subjects yet!",
          fontWeight: FontWeight.bold,
          buttons: <Widget>[
            FlatButton(
              child: Text('ADD A SUBJECT'),
              onPressed: () {
                Globals.coursesStore.courseName = course.name;
                Globals.coursesStore.courseId = course.id;
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => EditSubjectScreen()
                ));
              },
              color: kAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            )
          ],
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
