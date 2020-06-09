import 'package:studio/models/question.dart';
import 'package:studio/models/test_result.dart';

class TestService
{
  final List<Question> questions;
  final int length;
  List<bool> responses = new List();

  int index = 0;

  TestService(this.questions, this.length)
  {
    print("[Test service] ${questions.length} $length");
  }

  void setResponse(value) {
    responses.add(value);
  }

  bool hasMore() {
    return index < questions.length;
  }

  Question next() {
    if(questions.length == index) {
      print("[TestService] test completed");
      return null;
    }
    return questions[index++];
  }

  TestResult result() {
    var r = TestResult();
    r.questionsCount = questions.length;
    r.correct = responses.where((element) => element).length;
    r.wrong = r.questionsCount - r.correct;
    return r;
  }
}