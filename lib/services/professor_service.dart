import 'package:flutter/cupertino.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/note.dart';
import 'package:studio/models/question.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/models/test_result.dart';

enum ProfessorAdvice {
  AddCourse, AddSubjects, AddNotesAndQuestions, AddQuestions, MakeTest
}

class Professor {
  List<Course> courses;
  List<Subject> subjects;
  List<Note> notes;
  List<Question> questions;
  List<TestResult> tests;

  Professor({
    @required this.courses,
    @required this.subjects,
    @required this.notes,
    @required this.questions,
    @required this.tests
  }) {
    this.courses = this.courses ?? List();
    this.subjects = this.subjects ?? List();
    this.notes = this.notes ?? List();
    this.questions = this.questions ?? List();
    this.tests = this.tests ?? List();

    this.courses.forEach((c) {
      c.subjects = this.subjects.where((s) => s.courseId == c.id);
    });
    this.subjects.forEach((s) {
      s.notes = this.notes.where((element) => element.subjectId == s.id);
      s.questions = this.questions.where((element) => element.subjectId == s.id);
    });
  }

  ProfessorAdviceResult advice() {
    /**
     * User has no courses yet
     */
    if(courses.isEmpty) {
      return ProfessorAdviceResult(advice: ProfessorAdvice.AddCourse);
    }

    /**
     * User has an empty course
     */
    var emptyCourse = courses.firstWhere((c) => c.subjectsCount == 0);
    if(emptyCourse != null) {
      return ProfessorAdviceResult(
          advice: ProfessorAdvice.AddSubjects, course: emptyCourse);
    }

    /**
     * User has no notes yet
     */
    if(notes.isEmpty) {
      return ProfessorAdviceResult(
          advice: ProfessorAdvice.AddNotesAndQuestions,
          subject: this.subjects.first
      );
    }

    /**
     * User has an empty subject
     */
    var subject = this.subjects.firstWhere((element)
          => element.notes.isEmpty && element.questions.isEmpty);
    if(subject != null) {
      return ProfessorAdviceResult(
          advice: ProfessorAdvice.AddNotesAndQuestions,
          subject: subject,
          course: this.courses.firstWhere((element) => element.id == subject.courseId)
      );
    }

    /**
     * TODO check for tests with low score
     */

    /**
     * User should take a test
     */
    return ProfessorAdviceResult(
      advice: ProfessorAdvice.MakeTest
    );
  }
}

class ProfessorAdviceResult {
  final ProfessorAdvice advice;
  final Course course;
  final Subject subject;

  ProfessorAdviceResult({
    @required this.advice, this.course, this.subject
});
}