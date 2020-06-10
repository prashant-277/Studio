import 'note.dart';

class Question extends Note {
  String answer;
}

class QuestionResult extends Question {
  bool correct;

  QuestionResult(Question question)
  {
    this.correct = null;
    this.id = question.id;
    this.level = question.level;
    this.answer = question.answer;
    this.text = question.text;
    this.courseId = question.courseId;
    this.subjectId = question.subjectId;
    this.bookmark = question.bookmark;
    this.attention = question.attention;
    this.userId = question.userId;
    this.created = question.created;
  }
}