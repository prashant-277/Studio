import 'package:json_annotation/json_annotation.dart';
import 'package:studio/models/subject_stat.dart';
import 'package:studio/models/test_stat.dart';

class CourseStats {
  String id;
  String name;
  String icon;
  List<SubjectStat> subjects;
  List<TestStat> tests;

  CourseStats() {
    subjects = List();
    tests = List();
  }

  Map<String, dynamic> serialize() {
    Map<String, dynamic> data = Map();
    data["id"] = id;
    data["name"] = name;
    data["icon"] = icon;

    if(subjects != null && subjects.length > 0) {
      var subjectsData = List();
      subjects.forEach((element) {
        subjectsData.add(element.serialize());
      });
      data["subjects"] = subjectsData;
    }

    if(tests != null && tests.length > 0) {
      var testData = List();
      tests.forEach((element) {
        testData.add(element.serialize());
      });
      data["tests"] = testData;
    }
    return data;
  }

  static CourseStats deserialize(Map<String, dynamic> data) {
    CourseStats courseStats = CourseStats();
    courseStats.name = data["name"];
    courseStats.id = data["id"];
    courseStats.icon = data["icon"];
    if(data["subjects"] != null) {
      for(Map<String, dynamic> c in data["subjects"]) {
        courseStats.subjects.add(SubjectStat.deserialize(c));
      }
    }
    return courseStats;
  }
}
