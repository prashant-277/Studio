import 'package:studio/globals.dart';
import 'package:studio/models/subject.dart';

class Course {
  String userId;
  String id;
  String icon;
  String name;
  String nameDb;
  int subjectsCount;
  List<Subject> subjects;

  Course() {
    this.userId = Globals.userId;
  }

  static Course withData(Map<String, dynamic> data) {
    var course = Course();
    course.id = data["id"];
    course.userId = data['userId'];
    course.icon = data["icon"];
    course.name = data["name"];
    course.nameDb = data["nameDb"];
    course.subjectsCount = data["subjectsCount"];
    return course;
  }
}