
class SubjectStat {
  String name;
  String id;
  List<dynamic> wrong;
  bool questions;
  bool notes;

  SubjectStat() {
    wrong = List();
    notes = false;
    questions = false;
  }

  Map<String, dynamic> serialize() {
    Map<String, dynamic> data = Map();
    data["id"] = id;
    data["name"] = name;
    data["questions"] = questions;
    data["notes"] = notes;
    data["wrong"] = wrong;
    return data;
  }

  static SubjectStat deserialize(Map<String, dynamic> data) {
    SubjectStat subjectStat = SubjectStat();
    subjectStat.id = data["id"];
    subjectStat.name = data["name"];
    subjectStat.questions = data["questions"];
    subjectStat.notes = data["notes"] ?? false;
    subjectStat.wrong = data["wrong"] ?? false;
    return subjectStat;
  }
}