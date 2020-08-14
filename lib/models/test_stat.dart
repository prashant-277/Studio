import 'package:studio/models/subject_stat.dart';

class TestStat {
  DateTime dateTime;
  double result;
  List<SubjectStat> subjects;

  Map<String, dynamic> serialize() {
    Map<String, dynamic> data = Map();
    data["dateTime"] = dateTime;
    data["result"] = result;
    data["subjects"] = subjects.map((e) => e.serialize());

    return data;
  }
}