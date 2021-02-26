class Course {
  String userId;
  String id;
  String icon;
  String name;
  String nameDb;
  int subjectsCount;

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