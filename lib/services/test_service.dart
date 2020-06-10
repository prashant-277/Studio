import 'package:studio/models/question.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/models/test_result.dart';

class TestService
{
  final List<QuestionResult> questions;
  final int length;

  int index = -1;

  TestService(this.questions, this.length)
  {
    print("[Test service] ${questions.length} $length");
  }

  void setResponse(value) {
    questions[index].correct = value;
  }

  bool hasMore() {
    return index + 1 < questions.length;
  }

  Question next() {
    index++;
    if(questions.length == index) {
      print("[TestService] test completed");
      return null;
    }
    return questions[index];
  }

  TestResult result() {
    var r = TestResult();
    r.questionsCount = questions.length;
    r.correct = questions.where((element) => element.correct).length;
    r.wrong = r.questionsCount - r.correct;
    return r;
  }

  List<QuestionResult> wrongQuestions() {
    return questions.where((element) => !element.correct).toList();
  }

  List<QuestionResult> wrongQuestionsBySubject(Subject subject) {
    return questions.where((element) => !element.correct && element.subjectId == subject.id).toList();
  }

  List<Subject> wrongSubjects(Iterable<Subject> subjects) {
    var list = List<String>();
    wrongQuestions().forEach((element) {
      if(! list.contains(element.subjectId))
        list.add(element.subjectId);
    });

    return subjects.where((element) => list.contains(element.id)).toList();
  }

  bool hasErrors() {
    return questions.any((element) => !element.correct);
  }
}