import 'package:studio/models/subject_item.dart';

class Subject {
  String id;
  String userId;
  String courseId;
  String name;
  String nameDb;
  DateTime created;
  List<SubjectItem> items;
}