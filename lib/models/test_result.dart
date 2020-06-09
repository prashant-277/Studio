class TestResult
{
  int questionsCount;
  int correct;
  int wrong;

  int percentage() {
    if(questionsCount == 0)
      return 0;

    return (correct / questionsCount * 100).round();
  }
}