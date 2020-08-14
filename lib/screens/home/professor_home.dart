import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:studio/globals.dart';
import 'package:studio/models/course_stats.dart';
import 'package:studio/models/subject_stat.dart';
import 'package:studio/screens/home/fresh_start.dart';
import 'package:studio/screens/home/no_subjects.dart';
import 'package:studio/widgets/prof_card.dart';

import 'no_notes.dart';

class ProfessorHome extends StatefulWidget {
  @override
  _ProfessorHomeState createState() => _ProfessorHomeState();
}

class _ProfessorHomeState extends State<ProfessorHome> {

  Widget _profCard() {
    print("_profCard");

    if(Globals.authStore.stats == null ||
        Globals.authStore.stats.courses.length == 0)
      return FreshStartScreen();

    if(Globals.authStore.stats.courses.any((c) => c.subjects.length == 0)) {
      var noSubjects = Globals.authStore.stats.courses.firstWhere((element) =>
        element.subjects.length == 0
      );
      return NoSubjectScreen(noSubjects);
    }

    SubjectStat noNotesSubject;
    CourseStats noNotesCourse;
    Globals.authStore.stats.courses.forEach((c) {
      if(c.subjects.any((s) => !s.notes)) {
        noNotesSubject = c.subjects.firstWhere((s) => !s.notes);
        noNotesCourse = c;
      }
    });
    if(noNotesSubject != null)
      return NoNotesScreen(noNotesCourse, noNotesSubject);

    return Text('....');
  }

  @override
  Widget build(BuildContext context) {
    return _profCard();
  }
}
