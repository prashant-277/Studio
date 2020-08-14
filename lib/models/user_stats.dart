import 'course_stats.dart';

class UserStat {
  List<CourseStats> courses;

  UserStat() {
    courses = List();
  }

  static UserStat deserialize(Map<String, dynamic> data) {
    UserStat userStat = UserStat();
    if(data["courses"] != null) {
      for(Map<String, dynamic> c in data["courses"]) {
        userStat.courses.add(CourseStats.deserialize(c));
      }
    }
    return userStat;
  }

  Map<String, dynamic> serialize() {

    if(courses == null || courses.length == 0)
      return null;

    Map<String, dynamic> data = Map();
    data['courses'] = List();
    for(CourseStats c in courses) {
      data['courses'].add(c.serialize());
    }

    return data;
  }
}