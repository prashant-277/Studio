import 'package:studio/models/question.dart';

class TestResult
{
  String id;
  String userId;
  String courseId;
  List<Question> questions;

  int questionsCount;
  int correct;
  int wrong;

  int percentage() {
    if(questionsCount == 0)
      return 0;

    return (correct / questionsCount * 100).round();
  }
}