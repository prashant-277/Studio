import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/course_stats.dart';
import 'package:studio/models/subject_stat.dart';
import 'package:studio/screens/edit_note.dart';
import 'package:studio/widgets/prof_card.dart';

import '../../colors.dart';
import '../../globals.dart';

class NoNotesScreen extends StatelessWidget {
  final CourseStats course;
  final SubjectStat subject;

  NoNotesScreen(this.course, this.subject);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ProfCard(
          text: "${subject.name} has no key concepts yet!",
          fontWeight: FontWeight.bold,
          buttons: <Widget>[
            FlatButton(
              child: Text('ADD A KEY CONCEPT'),
              onPressed: () {
                Globals.coursesStore.courseName = course.name;
                Globals.coursesStore.courseId = course.id;
                Globals.coursesStore.subjectName = subject.name;
                Globals.coursesStore.subjectId = subject.id;
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EditNoteScreen()));
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
